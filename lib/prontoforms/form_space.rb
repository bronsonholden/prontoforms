require 'prontoforms/resource'

module ProntoForms
  class FormSpace < Resource
    property :id, key: 'identifier'
    property :name, key: 'name'
    property :problem_contact_email, key: 'problemContactEmail'
    property :push_updates_to_device, key: 'pushUpdatesToDevice'
  end
end
