require_relative 'base_model'

module Model
  class Order < BaseModel
    attr_accessor :date, :id, :number_of_products, :total, :total_products
  end
end
