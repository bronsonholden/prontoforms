# frozen_string_literal: true

require 'prontoforms/resource'

module ProntoForms
  # A form iteration is a form configuration, distinct from a form version
  # in that version numbers increment when a form iteration is deployed.
  class FormIteration < Resource
    def self.resource_name
      'iterations'
    end

    # @return [String] The form iteration identifier
    property :id, key: 'identifier'
    # @return [Integer] Version number
    property :version, key: 'version'
    # @return [String] Form iteration state
    property :state, key: 'state'
    # @return [String] Initiation method for the form iteration
    property :initiation_method, key: 'initiationMethod'
    # @return [String] Can dispatched forms of this iteration be declined
    property :dispatched_declinable, key: 'dispatchDeclinable'

    alias can_decline_dispatch? dispatched_declinable

    # @return [Array] Array of document IDs attached to this iteration
    def document_ids
      full_data.fetch('documentIds')
    end

    private



    def full_data
      return @full_data unless @full_data.nil?

      @full_data = parent.iteration(id).data
      @full_data
    end
  end
end
