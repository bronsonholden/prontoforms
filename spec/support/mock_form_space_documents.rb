# frozen_string_literal: true
module MockFormSpaceDocuments
  def self.registered(app)
    app.namespace '/documents' do
      get do
        json_response 200, (mock_paged_data(1000) { |i| mock_document(i) })
      end

      get '/:document_id' do
        json_response 200, mock_document(params['document_id'])
      end
    end
  end
end
