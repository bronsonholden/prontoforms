require 'date'

module ProntoForms
  class Resource
    attr_reader :data, :client, :parent

    def self.property(name, key: nil, &block)
      define_method(name) {
        if block_given?
          instance_eval(&block)
        elsif !key.nil?
          data.fetch(key)
        else
          nil
        end
      }
    end

    def initialize(data, client, parent = nil)
      @data = data
      @client = client
      @parent = parent
    end

    def self.resource_name
      name = self.to_s.split("::").last
      "#{name.downcase}s"
    end

    def resource_name
      self.class.resource_name
    end
  end
end
