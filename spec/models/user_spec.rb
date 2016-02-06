describe 'User', type: :model do
  subject { build(:user) }

  it { should be_valid }

  describe 'validations' do
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(1) }

    it { should validate_length_of(name).is_at_least(1) }
  end
end
