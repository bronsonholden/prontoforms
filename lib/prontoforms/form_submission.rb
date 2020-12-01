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
      client.form_space(data.dig('form', 'formSpaceId'))
    end

    # Retrieve the form for the form submission
    # @return [Form] Form for the submission
    def form
      client.form(data.dig('form', 'formId'))
    end

    # Retrieve the standard PDF document for the form submission
    # @return [IO] Readable stream containing the PDF contents
    def pdf
      io = StringIO.new
      client.connection.get do |req|
        req.url "#{resource_name}/#{id}/documents/#{pdf_document.id}"
        req.options.on_data = proc do |chunk|
          io << chunk
        end
      end

      io.rewind
      io
    end

    private

    # Retrieve the standard PDF document for the form submission
    # @return [Document] PDF document for the form submission
    # @raises RuntimeError
    def pdf_document
      document = form_space.documents.items.find do |doc|
        doc.type == 'Pdf' && doc.standard?
      end

      raise "No PDF document found for form space #{fs.id}" if document.nil?

      document
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
