require 'prontoforms/resource'

module ProntoForms
  # A wrapper for retrieving paged resources.
  class ResourceList < Resource
    # @return [Hash] Query parameters for this resource list for e.g. filters
    attr_reader :query
    # @return [Symbol] Method to send to parent object (usually the client)
    attr_reader :method
    # @return [Class] Resource class
    attr_reader :resource
    # @return [Client] API client
    attr_reader :client
    # @return [Resource] Parent object (for child resources)
    attr_reader :parent

    # Initialize the resource list
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
