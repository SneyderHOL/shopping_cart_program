require 'securerandom'

module Model
  # Base class for models
  class BaseModel
    attr_accessor :id

    def initialize(kwargs)
      self.id = SecureRandom.uuid
      kwargs.each do |key, value|
        send("#{key}=", value)
      end
    end

    def save
      Model::Engine::DataStorage.save(self)
    end

    def update(attributes)
      attributes.each do |att, value|
        send("#{att}=", value)
      end
    end

    def self.create(kwargs)
      resource = new(kwargs)
      resource.save
    end

    def self.all
      Model::Engine::DataStorage.all(name.to_s)
    end

    def self.list_resources_ids
      all.map(&:id)
    end

    def destroy
      Model::Engine::DataStorage.destroy(self)
    end

    def self.find(id)
      Model::Engine::DataStorage.find_resource(name.to_s, id)
    end

    def to_hash
      object_hash = {}
      instance_variables.map do |var|
        object_hash[var.to_s.gsub('@', '')] = instance_variable_get(var)
      end
      object_hash
    end

    def to_s
      to_hash.to_a.map { |attribute| attribute.join(' : ') }.join(', ')
    end

    def self.class_name
      name.split('::').last
    end
  end
end
