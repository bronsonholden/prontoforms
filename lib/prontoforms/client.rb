require 'faraday'
require 'json'
require 'prontoforms/resource_list'
require 'prontoforms/form_space'
require 'prontoforms/form_submission'

module ProntoForms
  class Client
    # @return [String]
    attr_reader :api_key_id
    # @return [String]
    attr_reader :api_key_secret

    # @param api_key_id Your ProntoForms REST API key
    # @param api_key_secret Your ProntoForms REST API secret
    def initialize(api_key_id, api_key_secret)
      @api_key_id = api_key_id
      @api_key_secret = api_key_secret
    end

    # Defines a resource that can be retrieved in a list
    # @return [nil]
    # @api private
    # @!macro [attach] resource_list
    #   @method $1
    #   Retrieve a list of $2 resources
    #   @return [ResourceList] A ResourceList containing $2 results
    def self.resource_list(method, resource, url = resource.resource_name)
      define_method(method) do |query: {}|
        res = connection.get do |req|
          req.url url
          query.each { |k, v| req.params[k] = v }
        end
        if res.success?
          ResourceList.new(JSON.parse(res.body), {
            'p' => 0,
            's' => 100
          }.merge(query), method, resource, self)
        else
          nil
        end
      end
    end

    resource_list :form_spaces, FormSpace
    resource_list :form_submissions, FormSubmission

    # Create a connection that can be used to execute a request against the
    # ProntoForms API.
    # @return [Faraday::Connection]
    # @api private
    def connection
      Faraday.new(url: 'https://api.prontoforms.com/api/1.1') do |conn|
        conn.basic_auth(api_key_id, api_key_secret)
      end
    end
  end
end
