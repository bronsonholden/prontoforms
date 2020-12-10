# frozen_string_literal: true

require 'support/mock_forms'

module MockFormSpaces
  # rubocop:disable Metrics/MethodLength
  def self.registered(app)
    app.register Sinatra::Namespace

    app.namespace '/formspaces' do
      get do
        json_response 200, (mock_paged_data { |i| mock_form_space(i) })
      end

      namespace '/:form_space_id' do
        get do
          json_response 200, mock_form_space(params['form_space_id'])
        end

        register MockForms
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
