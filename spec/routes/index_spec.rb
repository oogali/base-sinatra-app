describe '/', type: :request do
  describe 'GET' do
    subject { get '/' }
    it { expect(subject.status).to eq(200) }
  end
end
