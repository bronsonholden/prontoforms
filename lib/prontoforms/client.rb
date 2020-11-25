# frozen_string_literal: true

require 'faraday'
require 'json'
require 'prontoforms/resource_list'
require 'prontoforms/form_space'
require 'prontoforms/form_submission'
require 'prontoforms/user'

module ProntoForms
  # Allows you to retrieve resources from ProntoForms and perform other
  # functions with the API.
  class Client
    # @return [String] ProntoForms API key ID
    attr_reader :api_key_id
    # @return [String] ProntoForms API key secret
    attr_reader :api_key_secret

    # Create a client and use provided API credentials
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

        data = JSON.parse(res.body)

        return nil if data.fetch('pageData').size.zero?

        ResourceList.new(data, { 'p' => 0, 's' => 100 }.merge(query), method,
                         resource, self)
      end
    end

    resource_list :form_spaces, FormSpace
    resource_list :form_submissions, FormSubmission

    # Retrieve a user by identifier
    # @param id [String] The user identifier
    # @return [User] A User object for the requested user
    def user(id)
      raise ArgumentError, 'id must be provided' if id.nil?

      res = connection.get do |req|
        req.url "users/#{id}"
      end

      User.new(JSON.parse(res.body), self)
    end

    # Retrieve a form space by its identifier
    # @param id [String] The form space identifier
    # @return [FormSpace] A FormSpace object
    def form_space(id)
      raise ArgumentError, 'id must be provided' if id.nil?

      res = connection.get do |req|
        req.url "formspaces/#{id}"
      end

      FormSpace.new(JSON.parse(res.body), self)
    end

    # Retrieve a form submission by identifier
    # @param id [String] The form submission identifier
    # @return [FormSubmission] A FormSubmission object
    def form_submission(id)
      return nil if id.nil?

      res = connection.get do |req|
        req.url "data/#{id}"
      end

      FormSubmission.new(JSON.parse(res.body), self)
    end

    # Create a connection that can be used to execute a request against the
    # ProntoForms API.
    # @return [Faraday::Connection]
    # @api private
    def connection
      Faraday.new(url: 'https://api.prontoforms.com/api/1.1') do |conn|
        conn.basic_auth(api_key_id, api_key_secret)
        conn.use Faraday::Response::RaiseError
      end
    end
  end
end
