# frozen_string_literal: true

RSpec.describe ProntoForms::Form do
  let(:client) { ProntoForms::Client.new('key', 'secret') }
  let(:form_space) { client.form_space(1) }
  let(:forms) { form_space.forms }

  it 'can be retrieved by ID' do
    expect(form_space.form(1)).to be_a(ProntoForms::Form)
  end

  it 'can be retrieved in pages' do
    expect(forms.items).to all(be_a(ProntoForms::Form))
  end
end
