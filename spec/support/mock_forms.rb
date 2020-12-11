# frozen_string_literal: true

require 'support/mock_form_iterations'

module MockForms
  def self.registered(app)
    app.namespace '/forms' do
      get do
        json_response 200, (mock_paged_data { |i| mock_form(i) })
      end

      namespace '/:form_id' do
        get do
          json_response 200, mock_form(params['form_id'], paged: false)
        end

        register MockFormIterations
      end
    end
  end
end
