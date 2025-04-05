require 'rails_helper'

RSpec.describe Language, type: :model do
  describe 'validations' do
    subject { Language.new(name: 'English', code: 'en') }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a code' do
      subject.code = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate code' do
      subject.save
      duplicate_language = Language.new(name: 'Spanish', code: 'en')
      expect(duplicate_language).not_to be_valid
    end
  end

  context 'factory' do
    it 'has a valid factory' do
      expect(build(:language)).to be_valid
    end
  end
end
