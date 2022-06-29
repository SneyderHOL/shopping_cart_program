require_relative 'base_model'

module Model
  class Product < BaseModel
    attr_accessor :description, :id, :name, :price, :quantity

    def enough_stock_add_to_cart?(quantity_to_add)
      quantity_to_add <= quantity
    end
  end
end
