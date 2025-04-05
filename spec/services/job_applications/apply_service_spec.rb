require 'rails_helper'

RSpec.describe JobApplications::ApplyService, type: :service do
  let(:company) { create(:company) }
  let(:job) { create(:job, company: company) }
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, admin: true, company_id: company.id) }
  let(:another_user) { create(:user) }

  describe '.call' do
    context 'when user is not an admin of the company' do
      it 'successfully creates a job application' do
        service = described_class.call(user: user, job: job)

        expect(service).to be_success
        expect(service.job_application).to be_persisted
        expect(service.job_application.user).to eq(user)
        expect(service.job_application.job).to eq(job)
      end
    end

    context 'when user is an admin of the company' do
      it 'prevents job application' do
        service = described_class.call(user: admin_user, job: job)

        expect(service).not_to be_success
        expect(service.errors).to include("Company admins cannot apply to their own company's jobs")
        expect(service.job_application).to be_nil
      end
    end

    context 'when user applies to the same job twice' do
      it 'prevents duplicate application' do
        # First application
        first_service = described_class.call(user: user, job: job)
        expect(first_service).to be_success

        # Second application
        second_service = described_class.call(user: user, job: job)

        expect(second_service).not_to be_success
        expect(second_service.errors).to include("You have already applied to this job")
        expect(JobApplication.count).to eq(1)
      end
    end
  end
end
