require 'json'
require 'prontoforms/resource'

module ProntoForms
  class FormSubmission < Resource
    def self.resource_name() 'data'; end

    property :id, key: 'identifier'
    property :reference_number, key: 'referenceNumber'
    property :state, key: 'state'
    property :data_state, key: 'dataState'
    property :data_persisted, key: 'dataPersisted'
    property :form_version_id, key: 'formVersionId'
    property :form_id, key: 'formId'
    property :user_id, key: 'userId'
    property :username, key: 'username'
    # Aliases
    property :data_persisted?, key: 'dataPersisted'
    property :submitter_id, key: 'userId'
    property :submitter_username, key: 'username'
    property :dispatcher, key: 'dispatcher'

    property :server_receive_date do
      str = data.fetch('serverReceiveDate')
      str.nil? ? nil : DateTime.strptime(str)
    end

    # Retrieve the pages containing the form questions and answers
    # @return [Hash] Hash of questions and answers for the FormSubmission
    def pages
      document.fetch('pages')
    end

    # Retrieve the dispatching User, if the form was dispatched
    # @return [User] The user that dispatched the form, or nil
    def dispatcher
      client.user(document.dig('dispatcher', 'identifier'))
    end

    private

    # Returns additional data about the submission. Uses cached data,
    # otherwise it loads and returns the data via #document!
    def document
      return @document if !@document.nil?
      document!
    end

    # Force loads the submission document
    def document!
      res = client.connection.get do |req|
        req.url "#{resource_name}/#{id}/document.json"
      end
      if res.success?
        @document = JSON.parse(res.body)
        @document
      end
    end
  end
end
