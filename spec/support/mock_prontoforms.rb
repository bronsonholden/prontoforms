# frozen_string_literal: true

require 'json'
require 'sinatra/base'
require 'sinatra/namespace'
require 'support/mock_form_spaces'

class MockProntoForms < Sinatra::Base
  register Sinatra::Namespace

  def request_json
    request.body.rewind
    JSON.parse(request.body.read)
  end

  def json_response(status_code, data)
    content_type :json
    status status_code
    data.to_json
  end

  # Return paged mock data.
  # @param num [Integer] Total number of items
  # @param p [Integer] Page number to return
  # @param s [Integer] Page size
  def mock_paged_data(num = 1000, p = params.fetch('p', '1').to_i,
                            s = params.fetch('s', '100').to_i, &block)
    count = [num - (p * s), 0].max
    {
      'totalNumberOfResults' => num,
      'totalNumberOfPages' => (num / s) + 1,
      'zone' => nil,
      'pageData' => Array.new(count) { |i| block.call(p * s + i + 1) }
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

  def mock_form_version(id = 1)
    {
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
    data.merge!({
      'activeVersion' => mock_form_version,
      'draftVersion' => nil
    }) unless paged
    data
  end

  namespace '/api/1.1' do
    register MockFormSpaces
  end
end
