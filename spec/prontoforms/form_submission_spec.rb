# frozen_string_literal: true

RSpec.describe ProntoForms::FormSubmission do
  let(:client) { ProntoForms::Client.new('key', 'secret') }
  let(:form_submissions) { client.form_submissions }
  let(:form_submission) { form_submissions.items.first }
  let(:document) { form_submission.documents(populate: true).first }
  let(:contents) { form_submission.download_document(document).read }

  it 'has a form' do
    expect(form_submission.form).to be_a(ProntoForms::Form)
  end

  it 'has a form version' do
    expect(form_submission.form_version).to be_a(ProntoForms::FormIteration)
  end

  it 'documents can be download' do
    expect(contents).to eq('Mock document contents')
  end
end
