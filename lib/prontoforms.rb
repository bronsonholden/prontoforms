require 'prontoforms/version'
require 'prontoforms/client'

module ProntoForms
  class Error < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end
end
