require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  context 'validations' do
    it "requires an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires a unique email" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "requires a password" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "defaults to admin false" do
      user = create(:user)
      expect(user.admin?).to eq(false)
    end

    it "can only be linked to a company if its an admin" do
      user = create(:user, admin: false)
      company = create(:company)
      user.company = company
      user.save
      expect(user.errors.full_messages).to eq([ "Company can only be assigned to admin users" ])
    end
  end
end
