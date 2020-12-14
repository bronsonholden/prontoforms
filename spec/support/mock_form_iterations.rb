# frozen_string_literal: true

module MockFormIterations
  # rubocop:disable Metrics/MethodLength
  def self.registered(app)
    app.register Sinatra::Namespace

    app.namespace '/iterations' do
      get do
        json_response 200, (mock_paged_data { |i| mock_form_version(i) })
      end

      namespace '/:form_iteration_id' do
        get do
          json_response 200, mock_form_version(params['form_iteration_id'],
                                               paged: false)
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
