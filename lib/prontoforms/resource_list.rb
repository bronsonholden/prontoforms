require 'prontoforms/resource'

module ProntoForms
  class ResourceList < Resource
    attr_reader :limit, :offset, :method, :resource, :client, :parent

    def initialize(data, offset, limit, method, resource, client, parent = nil)
      super(data, client)
      @limit = limit
      @offset = offset
      @method = method
      @resource = resource
    end

    def next
      client.send(method, limit: limit, offset: offset + limit)
    end

    def items
      @data.fetch('pageData').map { |item|
        resource.new(item, client, parent)
      }
    end
  end
end
