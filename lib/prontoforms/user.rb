require 'prontoforms/resource'

module ProntoForms
  class User < Resource
    def self.resource_name() 'users'; end

    # @return [String] The User identifier
    property :id, key: 'identifier'
    # @return [String] The user's username
    property :username, key: 'username'
    # @return [String] The user's role
    property :role, key: 'role'
    # @return [String] The user's email address
    property :email, key: 'email'
    # @return [String] The user's first name
    property :first_name, key: 'firstName'
    # @return [String] The user's last name
    property :last_name, key: 'lastName'
    # @return [String] The user's preferred locale
    property :locale, key: 'locale'

    # Get a display name consisting of the first name followed by last name
    # e.g. "John Doe"
    # @return [String] The display name for the user
    def display_name
      "#{first_name} #{last_name}"
    end
  end
end
