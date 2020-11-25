# frozen_string_literal: true

RSpec.describe ProntoForms::ResourceList do
  let(:client) { ProntoForms::Client.new('key', 'secret') }

  it 'returns form spaces' do
    expect(client.form_spaces.items).to all(be_a(ProntoForms::FormSpace))
  end

  it 'returns next results' do
    expect(client.form_spaces.next.items).to all(be_a(ProntoForms::FormSpace))
  end

  it 'returns no results on last page' do
    expect(client.form_spaces(query: { 'p' => 9 }).next).to be_nil
  end
end
