require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:valid_attributes) do
    {
      title: "Software Engineer",
      hourly_salary: 50.0,
      company: create(:company)
    }
  end

  let(:job) { create(:job, valid_attributes) }

  context 'validations' do
    it "requires a title" do
      job = build(:job, title: nil)
      expect(job).not_to be_valid
      expect(job.errors[:title]).to include("can't be blank")
    end

    it "requires hourly_salary to be greater than 0" do
      job = build(:job, hourly_salary: 0)
      expect(job).not_to be_valid
      expect(job.errors[:hourly_salary]).to include("must be greater than 0")
    end

    it "requires a company" do
      job = build(:job, company: nil)
      expect(job).not_to be_valid
      expect(job.errors[:company]).to include("must exist")
    end
  end

  context 'factory' do
    it 'has a valid factory' do
      expect(build(:job)).to be_valid
    end
  end
end
