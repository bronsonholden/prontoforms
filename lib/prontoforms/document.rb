require 'prontoforms/resource'

module ProntoForms
  # A Document is a configuration that generates output data or files when
  # attached to a form.
  class Document < Resource
    def self.resource_name() 'documents'; end

    # @return [String] The Document identifier
    property :id, key: 'identifier'
    # @return [String] Document type
    property :type, key: 'type'
    # @return [String] Document name
    property :name, key: 'name'
    # @return [String] Document descriptiojn
    property :description, key: 'description'
    # @return [String] Document form version
    property :form_document_version, key: 'formDocumentVersion'
    # @return [Boolean] Whether the document is standard (system generated)
    property :standard, key: 'standard'
    # @return [String] Whether the document auto-links to new forms
    property :auto_link, key: 'autoLink'

    alias_method :standard?, :standard
    alias_method :auto_link?, :auto_link
  end
end
