require 'prontoforms/resource'

module ProntoForms
  class FormSpace < Resource
    # @return [String] The FormSpace identifier
    property :id, key: 'identifier'
    # @return [String] The FormSpace name
    property :name, key: 'name'
    # @return [String] The address that error emails are sent to
    property :problem_contact_email, key: 'problemContactEmail'
    # @return [Boolean] Whether updates are automatically pushed to devices
    property :push_updates_to_device, key: 'pushUpdatesToDevice'
  end
end
