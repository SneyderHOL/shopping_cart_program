require_relative '../helper/menus'
require 'ostruct'

module View
  # Prompt module containing all views use in app
  module Prompt
    include ::Helper::Menus

    def self.login
      puts "\nPlease log in\n"
      puts 'Enter email'
      email = gets.chomp
      puts 'Enter password'
      password = gets.chomp
      OpenStruct.new(email: email, password: password)
    end

    def self.main_menu
      show_submenu('Main', MAIN_MENU)
    end

    def self.display_actions_in_submenu(action_hash)
      print_line
      print_menu(action_hash)
      puts sufix_message
      gets.chomp
    end

    def self.show_submenu(submenu, submenu_hash)
      menu = submenu.downcase == 'main' ? "#{submenu} menu" : "#{submenu} submenu"
      print_line
      print "This is the #{menu}"
      print_line
      print_menu(submenu_hash)
      puts sufix_message
    end

    def self.cart_actions
      CART_ACTIONS.to_s
    end

    def self.logout
      puts "\nYou have log out\n"
    end

    def self.print_line
      print "\n#{'-' * 25}\n"
    end

    def self.exit_program
      puts "\nGood bye"
    end

    def self.welcome_back(name)
      puts "\nWelcome back #{name}\n"
    end

    def self.new_user
      puts "\nYou have been registered in the app\n"
    end

    def self.sufix_message
      "\nWhat would you like to do?\n"
    end

    def self.invalid_input
      puts "\nWrong input!!\n"
    end

    def self.print_menu(menu)
      menu.each do |key, value|
        puts "#{key} -> #{value[:name]}"
      end
    end

    def self.edit_product
      puts 'Name of the product'
      name = gets.chomp
      puts 'Description of the product'
      description = gets.chomp
      puts 'Price of the product'
      price = gets.chomp.to_f.round(2)
      puts 'Quantity of the product'
      quantity = gets.chomp.to_i
      { name: name, description: description, price: price, quantity: quantity }
    end

    def self.create_product
      puts "\nEnter the following information to create the product\n"
      edit_product
    end

    def self.update_product
      puts "\nEnter the following information to edit the product\n"
      edit_product
    end

    def self.empty_resources
      puts "\nNo resources\n"
    end

    def self.resource_created
      puts "\nThe resource has been created successfully"
    end

    def self.resource_updated
      puts "\nThe resource has been updated successfully"
    end

    def self.resource_deleted
      puts "\nThe resource has been deleted successfully"
    end

    def self.print_resources(products)
      puts products
    end

    def self.print_list_of_resources(resource_name, resources)
      puts "\nList of #{resource_name}:"
      return empty_resources if resources.empty?

      puts resources
    end

    def self.delete_resource
      puts "\nInsert id of the resource you would like to delete"
      id = gets.chomp
      puts 'Are you sure you want to delete this resource? (Insert yes to confirm)'
      confirmation = gets.chomp.downcase
      return id if confirmation == 'yes'

      nil
    end

    def self.edit_resource
      puts "\nInsert id of the resource you would like to edit\n"
      gets.chomp
    end

    def self.not_found
      puts "\nThe resource was not found"
    end

    def self.product_id_add_to_cart
      puts "\nInsert id of the product you would like to add to the cart"
      gets.chomp
    end

    def self.order_id_to_display
      puts "\nInsert id of the order you would like to see"
      gets.chomp
    end

    def self.product_quantity_add_to_cart
      puts 'Insert the quantity you would like to add to cart'
      gets.chomp
    end

    def self.not_enough_stock
      puts "\nThere is not enough stock of that product to add to cart"
    end

    def self.processing_order
      puts "\nThe order is being processed"
    end

    def self.not_enough_stock_to_place_order(product_name = nil)
      puts "\nThere is not enough stock of #{product_name} to place the order"
    end

    def self.empty_cart
      print "\nNo products in cart\n"
    end

    def self.product_added_to_cart
      puts "\nYou have added product to cart"
    end

    def self.order_saved
      puts "\nYou order was saved"
    end
  end
end
