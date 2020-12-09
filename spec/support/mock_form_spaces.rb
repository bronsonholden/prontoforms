# frozen_string_literal: true

module MockFormSpaces
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.registered(app)
    app.register Sinatra::Namespace

    app.namespace '/formspaces' do
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

      get '/:id' do
        json_response 200, mock_form_space
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
