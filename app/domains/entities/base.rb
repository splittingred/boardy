module Entities
  class Base < Dry::Struct
    transform_keys(&:to_sym)

    attr_reader :primary_key_field

    def persisted?
      primary_key_field.nil? ? !id.to_s.empty? : !send(primary_key_field).to_s.empty?
    end

    # Resolve default types on nil
    transform_types do |type|
      if type.default?
        type.constructor do |value|
          value.nil? ? Dry::Types::Undefined : value
        end
      else
        # Make all types omittable
        type.meta(omittable: true)
      end
    end

    def self.attribute(name, type = nil, &block)
      super
      define_attribute_setter(name)
    end

    def self.define_attribute_setter(name)
      define_method("#{name}=") do |value|
        self.attributes = attributes.merge(name => value)
      end
    end

    def attributes=(new_attributes)
      @attributes = self.class.input[new_attributes]
    end
  end
end
