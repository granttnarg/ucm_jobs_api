
require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  let(:company) { create(:company) }
  let(:admin_user) { create(:user, admin: true, company:) }
  let(:user) { create(:user, admin: false) }

  let(:job) { create(:job, company: company, creator: admin_user) }

  context 'factory' do
    it "has a valid factory" do
      job_application = build(:job_application, user: user, job: job)
      expect(job_application).to be_valid
    end
  end

  context 'validations' do
    it "requires a user" do
      job_application = build(:job_application, user: nil)
      expect(job_application).not_to be_valid
      expect(job_application.errors[:user]).to include("must exist")
    end

    it "requires a job" do
      job_application = build(:job_application, job: nil)
      expect(job_application).not_to be_valid
      expect(job_application.errors[:job]).to include("must exist")
    end

    it "prevents a user from applying to the same job twice" do
      create(:job_application, user: user, job: job)

      # Try to create a second application for the same user/job
      duplicate_application = build(:job_application, user: user, job: job)

      expect(duplicate_application).not_to be_valid
      expect(duplicate_application.errors[:user_id]).to include("has already applied to this job")
    end
  end
end
