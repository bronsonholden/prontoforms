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

    # Get the identifier for the active form iteration
    # @return [Integer] The active form iteration identifier
    def active_version_id
      full_data.dig('activeVersion', 'identifier')
    end

    # Retrieve the latest iteration of the form
    # @return [FormIteration] The latest form iteration
    def current_version
      iteration(active_version_id)
    end

    # Retrieve a form iteration by its identifier
    # @return [FormIteration] The latest form iteration
    def iteration(id)
      raise ArgumentError, 'id must be provided' if id.nil?

      res = client.connection.get do |req|
        req.url "#{url}/iterations/#{id}"
      end

      FormIteration.new(JSON.parse(res.body), client, self)
    end

    # Retrieve all iterations of the form
    # @return [ResourceList] Resource list containing form iterations
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

    def full_data
      client.form_space(form_space_id).form(id).data
    end

    # Get the resource path for this form
    # @return [String] Formatted resource path
    def url
      "formspaces/#{form_space_id}/forms/#{id}"
    end
  end
end
