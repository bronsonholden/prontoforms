# frozen_string_literal: true

module MockFormSpaces
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.registered(app)
    app.register Sinatra::Namespace

    app.namespace '/formspaces' do
      get do
        json_response 200, mock_paged_data { |i| mock_form_space(i) }
      end

      get '/:id' do
        json_response 200, mock_form_space
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
