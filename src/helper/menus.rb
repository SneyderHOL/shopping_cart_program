module Helper
  module Menus
    MAIN_MENU = {
      '1' => { name: 'Products Submenu', action: :product_submenu },
      '2' => { name: 'Orders Submenu', action: :order_submenu },
      '3' => { name: 'Cart Submenu', action: :cart_submenu },
      '4' => { name: 'Logout', action: :logout },
      'q' => { name: 'Exit', action: :exit_program }
    }.freeze
    GET_BACK = {
      'b' => { name: 'Get back to previous menu', action: :back }
    }.freeze
    PRODUCT_SUBMENU = {
      '1' => { name: 'Create product', action: :create_product },
      '2' => { name: 'List products', action: :list_products },
      '3' => { name: 'Edit product', action: :edit_product },
      '4' => { name: 'Delete a product', action: :delete_product }
    }.merge(GET_BACK).freeze
    ADD_PRODUCT_ACTIONS = {
      '1' => { name: 'Add product to cart', action: :add_product_to_cart }
    }.merge(GET_BACK).freeze
    ORDER_SUBMENU = {
      '1' => { name: 'List my orders', action: :list_orders }
    }.merge(GET_BACK).freeze
    DISPLAY_ORDER = {
      '1' => { name: 'Display order information', action: :display_order_information }
    }.merge(GET_BACK).freeze
    CART_SUBMENU = {
      '1' => { name: 'List products with name and quantity', action: :list_products_in_cart }
    }.merge(GET_BACK).freeze
    CART_ACTIONS = {
      '1' => { name: 'Update quantity', action: :update_product_quantity_in_cart },
      '2' => { name: 'Remove product', action: :remove_product_in_cart },
      '3' => { name: 'Place order', action: :place_order }
    }.merge(GET_BACK).freeze
  end
end
