# frozen_string_literal: true

require 'json'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/streaming'
require 'support/mock_form_spaces'
require 'support/mock_form_submissions'

# rubocop:disable Metrics/ClassLength
class MockProntoForms < Sinatra::Base
  register Sinatra::Namespace
  register Sinatra::Streaming

  def request_json
    request.body.rewind
    JSON.parse(request.body.read)
  end

  def json_response(status_code, data)
    content_type :json
    status status_code
    data.to_json
  end

  # Disable cops for mock data methods
  # rubocop:disable Metrics/MethodLength

  # Return paged mock data.
  # @param num [Integer] Total number of items
  # @param p [Integer] Page number to return
  # @param s [Integer] Page size
  def mock_paged_data(num = 1000, page = params.fetch('p', '1').to_i,
                      size = params.fetch('s', '100').to_i, &block)
    count = [num - (page * size), 0].max
    {
      'totalNumberOfResults' => num,
      'totalNumberOfPages' => (num / size) + 1,
      'zone' => nil,
      'pageData' => Array.new(count) { |i| block.call(page * size + i + 1) }
    }
  end

  def mock_form_space(id = 1)
    {
      'identifier' => id.to_s,
      'name' => "Form Space ##{id}",
      'problemContactEmail' => 'johndoe@email.com',
      'pushUpdatesToDevice' => false
    }
  end

  def mock_form_version(id = 1, paged: true)
    data = {
      'identifier' => id.to_s,
      'modelVersion' => 'v2',
      'asyncStatus' => nil,
      'name' => "Form version ##{id}",
      'description' => "A form version with identifier #{id}",
      'tags' => %w[form-version doodads thingamabobs],
      'state' => 'Active',
      'version' => 10,
      'passthrough' => false,
      'initiationMethod' => 'Both',
      'dispatchDeclinable' => false,
      'editable' => 'NotEditable',
      'notes' => 'Form version notes'
    }

    unless paged
      data.merge!({
        'destinations' => Array.new(5) do |i|
          {
            'destinationId' => i.to_s,
            'documentIds' => [i.to_s]
          }
        end,
        'documentIds' => Array.new(5) { |i| i }
      })
    end

    data
  end

  def mock_form(id = 1, paged: true)
    data = {
      'identifier' => id.to_s,
      'asyncStatus' => nil,
      'name' => "Form ##{id}",
      'description' => "A form with identifier #{id}",
      'state' => 'Active',
      'locked' => false
    }

    return data if paged

    data.merge({
      'activeVersion' => mock_form_version,
      'draftVersion' => nil
    })
  end

  def mock_form_submission(id = 1, paged: true)
    data = {
      'identifier' => id.to_s,
      'referenceNumber' => '20000101-12345678910',
      'state' => 'Dispatch',
      'dataState' => 'Dispatched',
      'actionState' => nil,
      'dataPersisted' => true,
      'serverReceiveDate' => nil,
      'userId' => '131234567',
      'username' => 'johndoe@email.com'
    }

    unless paged
      data.merge!({
        'form': {
          'formSpaceId' => '123456789',
          'formId' => '123456789',
          'formVersionId' => '1234567890'
        },
        'name' => "Form Submission Name (#{id})",
        'dispatchingTimestamp' => '2000-01-01T00:00:00Z',
        'dispatchedTimestamp' => '2000-01-01T00:00:00Z',
        'uploadingTimestamp': nil,
        'uploadedTimestamp': nil,
        'processingTimestamp': nil,
        'processedTimestamp': nil,
        'sentForEditTimestamp': nil,
        'receivedForEditTimestamp': nil,
        'passthrough': false,
        'edited': false,
        'entryTimestamp' => '2000-01-01T00:00:00Z',
        'userId' => '123456789',
        'dispatchMetadata': nil,
        'workflowInitiatorId' => '18123456789',
        'workflowNextStepIds': [],
        'processorExecutions': Array.new(5) do |i|
          mock_processor_execution(i)
        end
      })
      # Keys which are only present in the paged response data
      paged_only_keys = %w[actionState dataPersisted serverReceiveDate
                           userId username]
      data.delete_if { |key| paged_only_keys.include?(key) }
    end

    data
  end

  def mock_processor_execution(id = 1)
    {
      'identifier' => id.to_s,
      'processorType' => 'RecordAnalyticsTransaction',
      'stopAutomaticRetries': false,
      'reExecutable': true,
      'failureCount': 0,
      'processedMessage' => 'Execution message',
      'detailedErrorMessage': nil,
      'processedState' => 'Filtered',
      'processedTimestamp' => '2000-01-01T00:00:00Z',
      'state' => 'Filtered',
      'destinationType': nil,
      'destinationId': nil
    }
  end

  # rubocop:enable Metrics/MethodLength

  namespace '/api/1.1' do
    register MockFormSpaces
    register MockFormSubmissions
  end
end
# rubocop:enable Metrics/ClassLength
