require 'prontoforms/resource'

module ProntoForms
  class User < Resource
    def self.resource_name() 'users'; end

    property :id, key: 'identifier'
    property :username, key: 'username'
    property :role, key: 'role'
    property :email, key: 'email'
    property :first_name, key: 'firstName'
    property :last_name, key: 'lastName'
    property :locale, key: 'locale'

    def display_name
      "#{first_name} #{last_name}"
    end
  end
end
