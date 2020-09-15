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

    property :dispatcher do
      client.user(data.dig('dispatcher', 'identifier'))
    end

    property :server_receive_date do
      str = data.fetch('serverReceiveDate')
      str.nil? ? nil : DateTime.strptime(str)
    end

    def pages
      res = client.connection.get do |req|
        req.url "#{resource_name}/#{id}/document.json"
      end
      if res.success?
        JSON.parse(res.body).fetch('pages')
      end
    end
  end
end
