require_relative 'base_model'

module Model
  class Order < BaseModel
    attr_accessor :date, :total, :number_of_products, :total_products, :id
  end
end
