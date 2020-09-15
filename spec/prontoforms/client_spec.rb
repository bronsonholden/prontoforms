RSpec.describe ProntoForms::Client do
  describe 'invalid resource verb' do
    let(:klass) {
      class InvalidClient < ProntoForms::Client; end
      InvalidClient
    }

    let(:resource_klass) {
      class InvalidResource < ProntoForms::Resource
        def resource_name() 'invalid'; end
      end
      InvalidResource
    }

    it 'raises error' do
      expect {
        # Define a bogus resource and expect an error
        klass.resource 'method', verb: :notaverb, resource: resource_klass
      }.to raise_error(ProntoForms::InvalidHttpVerb)
    end
  end
end
