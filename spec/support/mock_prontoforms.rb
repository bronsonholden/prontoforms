# frozen_string_literal: true

require 'json'
require 'sinatra/base'
require 'sinatra/namespace'

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
    namespace '/formspaces' do
      get do
        num = 1000
        s = params.fetch('s', '100').to_i
        p = params.fetch('p', '0').to_i
        size = [num - (p * s), 0].max
        json_response 200, {
          'totalNumberOfResults' => num,
          'totalNumberOfPages' => (num / s) + 1,
          'zone' => nil,
          'pageData' => Array.new(size) { |i| mock_form_space(p * s + i + 1) }
        }
      end
    end
  end
end
