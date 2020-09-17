require 'json'
require 'prontoforms/resource'

module ProntoForms
  class FormSubmission < Resource
    def self.resource_name() 'data'; end

    # @return [String] The FormSubmission identifier
    property :id, key: 'identifier'
    # @return [String] Submission reference number
    property :reference_number, key: 'referenceNumber'
    # @return [String] Submission state. One of: Complete, Processing, Dispatched
    property :state, key: 'state'
    # @return [String] Submission data state
    property :data_state, key: 'dataState'
    # @return [Boolean] Has the submission data been persisted on the server
    property :data_persisted, key: 'dataPersisted'
    # @return [String] The form's version identifier
    property :form_version_id, key: 'formVersionId'
    # @return [String] The form's identifier
    property :form_id, key: 'formId'
    # @return [String] Submitter's user identifier
    property :user_id, key: 'userId'
    # @return [String] Submitter's username
    property :username, key: 'username'

    alias_method :data_persisted?, :data_persisted
    alias_method :submitter_id, :user_id
    alias_method :submitter_username, :username

    # @return [DateTime] Timestamp the submission was received by the server
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
