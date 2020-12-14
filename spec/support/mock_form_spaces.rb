# frozen_string_literal: true

require 'support/mock_forms'
require 'support/mock_form_space_documents'

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
        register MockFormSpaceDocuments
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
