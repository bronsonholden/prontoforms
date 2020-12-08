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

  def mock_form_space(id)
    {
      'identifier' => id.to_s,
      'name' => "Form Space ##{id}",
      'problemContactEmail' => 'johndoe@email.com',
      'pushUpdatesToDevice' => false
    }
  end

  namespace '/api/1.1' do
    register MockFormSpaces
  end
end
