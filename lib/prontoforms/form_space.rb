# frozen_string_literal: true

require 'prontoforms/resource'
require 'prontoforms/form'
require 'prontoforms/document'

module ProntoForms
  # Represents a form space resource in ProntoForms. Form spaces are the
  # primary organizational unit for forms, data sources, destinations, and
  # other resources.
  class FormSpace < Resource
    # @return [String] The FormSpace identifier
    property :id, key: 'identifier'
    # @return [String] The FormSpace name
    property :name, key: 'name'
    # @return [String] The address that error emails are sent to
    property :problem_contact_email, key: 'problemContactEmail'
    # @return [Boolean] Whether updates are automatically pushed to devices
    property :push_updates_to_device, key: 'pushUpdatesToDevice'

    # Get all documents in the form space
    # @return [ResourceList] A ResourceList containing Document objects
    def documents
      res = client.connection.get do |req|
        req.url "formspaces/#{id}/documents"
      end

      ResourceList.new(JSON.parse(res.body), {
        'p' => 0,
        's' => 100
      }, :documents, Document, self)
    end

    def document(document_id)
      res = client.connection.get do |req|
        req.url "formspaces/#{id}/documents/#{document_id}"
      end

      Document.new(JSON.parse(res.body), client, self)
    end

    def form(form_id)
      res = client.connection.get do |req|
        req.url "formspaces/#{id}/forms/#{form_id}"
      end

      data = JSON.parse(res.body)
      Form.new(data, client, self)
    end

    # Get all forms in the form space
    # @return [ResourceList] A ResourceList containing Form objects
    def forms(query: {})
      res = client.connection.get do |req|
        req.url "formspaces/#{id}/forms"
        query.each { |k, v| req.params[k] = v }
      end

      ResourceList.new(JSON.parse(res.body), {
        'p' => 0,
        's' => 100
      }.merge(query), :forms, Form, client, self)
    end
  end
end
