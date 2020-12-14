module MockFormSubmissionDocuments
  def self.registered(app)
    app.namespace '/documents' do
      get '/:form_submission_document_id' do
        stream do |out|
          out << 'Mock document contents'
        end
      end
    end
  end
end
