# frozen_string_literal: true

RSpec.describe ProntoForms::Form do
  let(:client) { ProntoForms::Client.new('key', 'secret') }
  let(:form_space) { client.form_space(1) }
  let(:forms) { form_space.forms }
  let(:form) { forms.items.first }

  it 'can be retrieved by ID' do
    expect(form_space.form(1)).to be_a(ProntoForms::Form)
  end

  it 'can be retrieved in pages' do
    expect(forms.items).to all(be_a(ProntoForms::Form))
  end

  it 'has a form space' do
    expect(form.form_space_id).to eq(form_space.id)
  end

  it 'has iterations' do
    expect(form.iterations.items).to all(be_a(ProntoForms::FormIteration))
  end

  it 'has a current version' do
    expect(form.current_version).to be_a(ProntoForms::FormIteration)
  end

  describe 'mock data' do
    context 'when paged' do
      it 'excludes additional data' do
        expect(forms.items.first.data.dig('activeVersion')).to be_nil
      end
    end

    context 'when individual' do
      it 'includes additional data' do
        expect(form_space.form(1).data.dig('activeVersion')).not_to be_nil
      end
    end
  end
end
