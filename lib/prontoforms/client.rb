require 'faraday'
require 'json'
require 'prontoforms/resource_list'
require 'prontoforms/form_space'
require 'prontoforms/form_submission'

module ProntoForms
  class Client
    attr_reader :api_key_id, :api_key_secret

    def initialize(api_key_id, api_key_secret)
      @api_key_id = api_key_id
      @api_key_secret = api_key_secret
    end

    def self.resource(method, verb: :get, resource:, url: resource.resource_name)
      # TODO: Raise error if verb is invalid

      define_method(method) do |query: {}|
        res = connection.send(verb) do |req|
          req.url url
          query.each { |k, v| req.params[k] = v }
        end
        if res.success?
          ResourceList.new(JSON.parse(res.body), 0, 20, method, resource, self)
        else
          nil
        end
      end
    end

    resource :form_spaces, resource: FormSpace
    resource :form_submissions, resource: FormSubmission

    def connection
      Faraday.new(url: 'https://api.prontoforms.com/api/1.1') do |conn|
        conn.basic_auth(api_key_id, api_key_secret)
      end
    end
  end
end
