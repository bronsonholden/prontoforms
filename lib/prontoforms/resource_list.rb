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

    # Retrieve the next page of results, using the same number of items per
    # page as the original request.
    # @return [ResourceList] A ResourceList with the next set of results
    def next
      client.send(method, query: query.merge({ 'p' => query['p'] + 1}))
    end

    # Retrieve the result set
    # @return [Array] Array of resource objects
    def items
      @data.fetch('pageData').map { |item|
        resource.new(item, client, parent)
      }
    end
  end
end
