require 'prontoforms/resource'
require 'prontoforms/form'

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

    # Get all forms in the form space
    # @return [ResourceList] A ResourceList containing Form objects
    def forms(query: {})
      res = client.connection.get do |req|
        req.url "formspaces/#{id}/forms"
        query.each { |k, v| req.params[k] = v }
      end
      if res.success?
        ResourceList.new(JSON.parse(res.body), {
          'p' => 0,
          's' => 100
        }.merge(query), :forms, Form, self)
      else
        nil
      end
    end
  end
end
