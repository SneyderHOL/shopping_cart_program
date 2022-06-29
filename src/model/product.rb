require_relative 'base_model'

module Model
  class Product < BaseModel
    attr_accessor :name, :description, :price, :quantity, :id

    def enough_stock_add_to_cart?(quantity_to_add)
      quantity_to_add <= quantity
    end
  end
end
