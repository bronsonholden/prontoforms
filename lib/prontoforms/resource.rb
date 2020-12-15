# frozen_string_literal: true

require 'date'

module ProntoForms
  # Base class for resource-related classes.
  class Resource
    # @return [Hash] Retrieve raw JSON data associated with this resource
    attr_reader :data
    # @return [Client] API client
    attr_reader :client
    # @return [Resource] Parent object (applicable to child resources)
    attr_reader :parent

    # Defines a property of the resource
    # @return [nil]
    # @api private
    def self.property(name, key: nil, full: false, &block)
      define_method(name) do
        if block_given?
          instance_eval(&block)
        elsif !key.nil?
          key = [key] unless key.is_a?(Array)
          source = full ? cached_full_data : data
          key.inject(source) { |obj, k| obj.fetch(k) }
        end
      end
    end

    def initialize(data, client, parent = nil)
      @data = data
      @client = client
      @parent = parent
    end

    # The resource's identifier
    def self.resource_name
      name = to_s.split('::').last
      "#{name.downcase}s"
    end

    # The resource's identifier
    def resource_name
      self.class.resource_name
    end

    protected

    # Return complete resource data. When returned in paged responses,
    # some data is excluded. This varies from resource to resource, but most
    # have some data fields that are unavailable except when retrieving
    # specific resource instances.
    # @return [Hash] Full data
    def full_data
      data
    end

    # Loads full data if not already stored, and returns it
    # @return [Hash] Full data, using previously loaded data if present
    def cached_full_data
      return @full_data unless @full_data.nil?

      @full_data = full_data
      @full_data
    end
  end
end
