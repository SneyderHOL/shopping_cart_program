require 'byebug'
module Model
  module Engine
    # DataStorage module to save/read data
    class DataStorage
      @@objects = {}
      @@user_email = nil
      @@user_password = nil

      def self.all(key)
        resources = find_resources(key)
        resources.values
      end

      def self.save(resource)
        key = resource.class.to_s
        resources = find_resources(key)
        resources[resource.id] = resource
        @@objects[key] = resources
        resource
      end

      def self.destroy(resource)
        key = resource.class.to_s
        id = resource.id
        @@objects[key].delete(id)
      end

      def self.find_resource(key, id)
        find_resources(key)[id]
      end

      def self.find_resources(key)
        @@objects[key] || {}
      end

      def self.save_user(email, password)
        @@user_email = email
        @@user_password = password
      end

      def self.find_user(email, password)
        return false unless email

        email == @@user_email && password == @@user_password
      end
    end
  end
end
