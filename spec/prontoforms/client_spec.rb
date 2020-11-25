# frozen_string_literal: true

RSpec.describe ProntoForms::Client do
  let(:client) { ProntoForms::Client.new('key', 'secret') }

  describe '#form_spaces' do
    it 'returns form spaces' do
      expect(client.form_spaces.items).to all(be_a(ProntoForms::FormSpace))
    end
  end
end
