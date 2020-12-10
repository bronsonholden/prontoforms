# frozen_string_literal: true

RSpec.describe ProntoForms::Form do
  let(:client) { ProntoForms::Client.new('key', 'secret') }

  it 'can be retrieved by ID' do
    expect(client.form_space(1).form(1)).to be_a(ProntoForms::Form)
  end
end
