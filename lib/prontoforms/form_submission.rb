# frozen_string_literal: true

require 'json'
require 'prontoforms/resource'

module ProntoForms
  # A FormSubmission represents submitted form data in ProntoForms. It
  # includes various metadata about the submission as well.
  class FormSubmission < Resource
    def self.resource_name
      'data'
    end

    # @return [String] The FormSubmission identifier
    property :id, key: 'identifier'
    # @return [String] Submission reference number
    property :reference_number, key: 'referenceNumber'
    # @return [String] Submission state. One of: Complete, Processing,
    #                  Dispatched
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

    alias data_persisted? data_persisted
    alias submitter_id user_id
    alias submitter_username username

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
      return nil unless dispatched?

      client.user(document.dig('dispatcher', 'identifier'))
    end

    # Check if the form was dispatched
    # @return [Boolean] True if the form was dispatched; false otherwise
    def dispatched?
      !document.dig('dispatcher', 'identifier').nil?
    end

    # Retrieve the form space for the form submission
    # @return [FormSpace] Form space for the submission's form
    def form_space
      client.form_space(full_data.dig('form', 'formSpaceId'))
    end

    # Retrieve the form for the form submission
    # @return [Form] Form for the submission
    def form
      form_space.form(full_data.dig('form', 'formId'))
    end

    # Retrieve the current version of the form
    # @return [FormIteration] The form iteration
    def form_version
      form.current_version
    end

    # Retrieve all documents attached to this form submission
    # @return [Array] Documents attached to the form submission
    def documents(populate: false)
      ids = form_version.document_ids
      if populate
        ids.map { |id| form_space.document(id) }
      else
        ids
      end
    end

    # Download a specific document. The Document must have been attached to
    # the form's current version at the time of submission.
    # @return [IO] Data stream for the document
    def download_document(document)
      io = StringIO.new
      client.connection.get do |req|
        req.url "#{url}/documents/#{document.id}"
        req.options.on_data = proc { |chunk| io << chunk }
      end
      io.rewind
      io
    end

    private

    def url
      "#{resource_name}/#{id}"
    end

    def full_data
      return @full_data unless @full_data.nil?

      @full_data = client.form_submission(id).data
      @full_data
    end

    # Returns additional data about the submission. Uses cached data,
    # otherwise it loads and returns the data via #document!
    def document
      return @document unless @document.nil?

      document!
    end

    # Force loads the submission document
    def document!
      res = client.connection.get do |req|
        req.url "#{resource_name}/#{id}/document.json"
      end

      @document = JSON.parse(res.body)
      @document
    end
  end
end
