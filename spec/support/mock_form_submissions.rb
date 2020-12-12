# frozen_string_literal: true

module MockFormSubmissions
  # rubocop:disable Metrics/MethodLength
  def self.registered(app)
    app.namespace '/data' do
      get do
        data = mock_paged_data(1000) { |i| mock_form_submission(i) }
        json_response 200, data
      end

      namespace '/:submission_id' do
        get do
          id = params['submission_id']
          json_response 200, mock_form_submission(id, paged: false)
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
