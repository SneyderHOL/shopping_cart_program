module Model
  class Cart
    @@products = {}
    # attr_accessor :date, :total, :number_of_products, :total_products, :id

    def self.add_product(id, quantity)
      @@products[id] = { quantity: quantity }
    end

    def self.remove_product(id)
      @@products.delete(id)
    end

    def self.clean
      @@products = {}
    end

    def self.all_products
      products = []
      @@products.each do |key, value|
        product_name = Model::Product.find(key).name
        products.push("id : #{key}, name : #{product_name}, quantity : #{value[:quantity]}")
      end
      products
    end

    def self.find_product(id)
      @@products[id]
    end

    def self.products
      @@products
    end
  end
end
