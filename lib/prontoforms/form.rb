require 'prontoforms/resource'

module ProntoForms
  class Form < Resource
    def self.resource_name() 'forms'; end

    # @return [String] The Form identifier
    property :id, key: 'identifier'
    # @return [String] Form name
    property :name, key: 'name'
    # @return [String] Form description
    property :description, key: 'description'
    # @return [String] Form state
    property :state, key: 'state'
  end
end
