# frozen_string_literal: true

require 'prontoforms/resource'
require 'prontoforms/form_iteration'

module ProntoForms
  # A form includes inputs, validations, logic, and other configuration that
  # facilitates data capture for a specific purpose.
  class Form < Resource
    def self.resource_name
      'forms'
    end

    # @return [String] The Form identifier
    property :id, key: 'identifier'
    # @return [String] Form name
    property :name, key: 'name'
    # @return [String] Form description
    property :description, key: 'description'
    # @return [String] Form state
    property :state, key: 'state'

    # Get the Form's form space ID
    # @return [String] Form space identifier
    def form_space_id
      parent.id
    end

    def iterations(query: {})
      res = client.connection.get do |req|
        req.url "#{url}/iterations"
      end

      ResourceList.new(JSON.parse(res.body), {
        'p' => 0,
        's' => 100
      }.merge(query), :iterations, FormIteration, client, self)
    end

    private

    def url
      "formspaces/#{form_space_id}/forms/#{id}"
    end
  end
end
