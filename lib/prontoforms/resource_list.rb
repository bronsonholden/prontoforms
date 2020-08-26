require 'prontoforms/resource'

module ProntoForms
  class ResourceList < Resource
    attr_reader :query, :method, :resource, :client, :parent

    def initialize(data, query, method, resource, client, parent = nil)
      super(data, client)
      @query = query
      @method = method
      @resource = resource
    end

    def next
      client.send(method, query: query.merge({ 'p' => query['p'] + 1}))
    end

    def items
      @data.fetch('pageData').map { |item|
        resource.new(item, client, parent)
      }
    end
  end
end
