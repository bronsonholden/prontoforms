# frozen_string_literal: true

require 'prontoforms/version'
require 'prontoforms/client'

module ProntoForms
  # Base error class.
  class Error < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end
end
