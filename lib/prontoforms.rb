require 'prontoforms/version'
require 'prontoforms/client'

module ProntoForms
  class Error < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end

  class InvalidHttpVerb < Error
    def initialize(verb)
      super("Invalid HTTP verb: #{verb}")
    end
  end
end
