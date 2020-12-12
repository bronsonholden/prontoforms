# frozen_string_literal: true

RSpec.describe ProntoForms::FormSubmission do
  let(:client) { ProntoForms::Client.new('key', 'secret') }
  let(:form_submissions) { client.form_submissions }
  let(:form_submission) { form_submissions.items.first }

  it 'has a form' do
    expect(form_submission.form).to be_a(ProntoForms::Form)
  end

  it 'has a form version' do
    expect(form_submission.form_version).to be_a(ProntoForms::FormIteration)
  end
end
