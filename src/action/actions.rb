require_relative '../model/engine/data_storage'

module Action
  module Actions
    include Helper::Menus

    def self.login
      resource = View::Prompt.login
      validate_user(resource)
    end

    def self.validate_user(user)
      if Model::Engine::DataStorage.find_user(user.email, user.password)
        View::Prompt.welcome_back(user.email)
      else
        Model::Engine::DataStorage.save_user(user.email, user.password)
        Model::Cart.clean
        View::Prompt.new_user
      end
    end

    def self.logout
      View::Prompt.logout
      true
    end

    # menus

    def self.main_menu(key)
      option = MAIN_MENU[key]
      if option.nil?
        View::Prompt.invalid_input
      elsif option[:action] == :logout
        logout
        true
      else
        loop do
          value = send(option[:action])
          next if value.nil?
          break if value

          return true
        end
      end
    end

    def self.product_submenu
      View::Prompt.show_submenu(Model::Product.class_name, PRODUCT_SUBMENU)
      submenu_navigation(PRODUCT_SUBMENU)
    end

    def self.order_submenu
      View::Prompt.show_submenu(Model::Order.class_name, ORDER_SUBMENU)
      submenu_navigation(ORDER_SUBMENU)
    end

    def self.cart_submenu
      View::Prompt.show_submenu('Cart', CART_SUBMENU)
      submenu_navigation(CART_SUBMENU)
    end

    def self.submenu_navigation(hash_submenu)
      input = gets.chomp.downcase
      option = hash_submenu[input]
      return View::Prompt.invalid_input if option.nil?
      return true if option[:action] == :back

      send(option[:action])
    end

    # product crud

    def self.create_product
      product_attributes = View::Prompt.create_product
      Model::Product.create(product_attributes)
      View::Prompt.resource_created
    end

    def self.list_products
      products = Model::Product.all
      View::Prompt.print_list_of_resources('Products', products)
      add_product_navigation
    end

    def self.add_product_navigation
      loop do
        input = View::Prompt.display_actions_in_submenu(ADD_PRODUCT_ACTIONS)
        option = ADD_PRODUCT_ACTIONS[input]
        if option.nil?
          View::Prompt.invalid_input
          next
        end
        break if option[:action] == :back

        id = View::Prompt.product_id_add_to_cart
        resource = Model::Product.find(id)
        unless resource
          View::Prompt.not_found
          next
        end

        quantity = View::Prompt.product_quantity_add_to_cart.to_i
        product_added = send(option[:action], resource, quantity)
        next unless product_added

        break
      end
    end

    def self.edit_product
      id = View::Prompt.edit_resource
      resource = Model::Product.find(id)
      return View::Prompt.not_found unless resource

      product_attributes = View::Prompt.update_product
      resource.update(product_attributes)
      View::Prompt.resource_updated
    end

    def self.delete_product
      id = View::Prompt.delete_resource
      return unless id

      resource = Model::Product.find(id)
      return View::Prompt.not_found unless resource

      resource.destroy
      Model::Cart.remove_product(resource.id)
      View::Prompt.resource_deleted
    end

    # list products actions

    def self.add_product_to_cart(resource, quantity)
      unless resource.enough_stock_add_to_cart?(quantity)
        View::Prompt.not_enough_stock
        return false
      end

      Model::Cart.add_product(resource.id, quantity)
      View::Prompt.product_added_to_cart
      true
    end

    # order actions

    def self.list_orders
      orders = Model::Order.list_resources_ids
      View::Prompt.print_list_of_resources('Orders', orders)
      display_order_navigation
    end

    # list order actions

    def self.display_order_navigation
      loop do
        input = View::Prompt.display_actions_in_submenu(DISPLAY_ORDER)
        option = DISPLAY_ORDER[input]
        if option.nil?
          View::Prompt.invalid_input
          next
        end
        break if option[:action] == :back

        id = View::Prompt.order_id_to_display
        resource = Model::Order.find(id)
        unless resource
          View::Prompt.not_found
          next
        end

        send(option[:action], resource)
        break
      end
    end

    def self.display_order_information(order)
      print "\nOrder information\n"
      puts order
    end

    # cart actions

    def self.list_products_in_cart
      View::Prompt.print_list_of_resources('Products in cart', Model::Cart.all_products)
      cart_navigation
    end

    def self.cart_navigation
      loop do
        input = View::Prompt.display_actions_in_submenu(CART_ACTIONS)
        option = CART_ACTIONS[input]
        if option.nil?
          View::Prompt.invalid_input
          next
        end
        break if option[:action] == :back

        action_result = send(option[:action])
        break if action_result
      end
    end

    # list products in cart actions

    def self.update_product_quantity_in_cart
      id = View::Prompt.edit_resource
      resource_in_cart = Model::Cart.find_product(id)
      return View::Prompt.not_found unless resource_in_cart

      resource = Model::Product.find(id)
      quantity = View::Prompt.product_quantity_add_to_cart.to_i
      unless resource.enough_stock_add_to_cart?(quantity)
        View::Prompt.not_enough_stock
        return false
      end

      quantity.zero? ? Model::Cart.remove_product(id) : Model::Cart.add_product(id, quantity)
      View::Prompt.resource_updated
      true
    end

    def self.remove_product_in_cart
      id = View::Prompt.delete_resource
      resource_in_cart = Model::Cart.remove_product(id)
      return View::Prompt.not_found unless resource_in_cart

      View::Prompt.resource_deleted
      true
    end

    def self.place_order
      return View::Prompt.empty_cart if Model::Cart.products.empty?

      View::Prompt.processing_order
      order_details = check_stock(Model::Cart.products)
      return unless order_details

      update_inventory
      create_order(*order_details)
      Model::Cart.clean
      View::Prompt.order_saved
      true
    end

    def self.check_stock(hash_products)
      number_of_products = total_products = total = 0
      hash_products.each do |key, value|
        resource = Model::Product.find(key)
        unless resource.enough_stock_add_to_cart?(value[:quantity])
          View::Prompt.not_enough_stock_to_place_order(resource.name)
          return false
        end
        number_of_products += 1
        total_products += value[:quantity]
        total += resource.price * value[:quantity]
      end
      [number_of_products, total_products, total]
    end

    def self.update_inventory
      Model::Cart.products.each do |key, value|
        resource = Model::Product.find(key)
        resource.update(quantity: resource.quantity - value[:quantity])
      end
    end

    def self.create_order(number_of_products, total_products, total)
      Model::Order.create(
        date: Time.now.utc.to_s, total: total, number_of_products: number_of_products,
        total_products: total_products
      )
    end

    # back action
    def self.back
      true
    end
  end
end
