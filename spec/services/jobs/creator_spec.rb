# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jobs::Creator do
  let(:company) { create(:company) }
  let(:user) { create(:user, company:, admin: true) }
  let(:english) { create(:language, code: 'en', name: 'English') }
  let(:german) { create(:language, code: 'de', name: 'German') }
  let(:valid_job_params) do
    {
      title: 'Software Engineer',
      hourly_salary: 20,
      language_codes: [ english.code, german.code ]
    }
  end

  describe '.call' do
    it 'delegates to a new instance' do
      creator = instance_double(described_class, call: true)
      expect(described_class).to receive(:new).with(valid_job_params, user, company).and_return(creator)
      expect(creator).to receive(:call)

      described_class.call(job_params: valid_job_params, user: user, company: company)
    end
  end

  describe '#call' do
    subject(:service_call) { described_class.new(job_params, user, company).call }

    context 'with valid parameters' do
      let(:job_params) { valid_job_params }

      it 'creates a job' do
        expect { service_call }.to change(Job, :count).by(1)
      end

      it 'sets the job creator to the provided user' do
        result = service_call
        expect(result.job.creator).to eq(user)
      end

      it 'sets the job company to the provided company' do
        result = service_call
        expect(result.job.company).to eq(company)
      end

      it 'returns a success status' do
        expect(service_call.success?).to be true
      end

      it 'returns an empty errors array' do
        expect(service_call.errors).to be_empty
      end
    end

    context 'with invalid parameters' do
      let(:job_params) { { title: '' } } # Missing required fields

      it 'does not create a job' do
        expect { service_call }.not_to change(Job, :count)
      end

      it 'returns a failure status' do
        expect(service_call.success?).to be false
      end

      it 'populates the errors array with validation messages' do
        result = service_call
        expect(result.errors).not_to be_empty
      end

      it 'rolls back the transaction' do
        allow_any_instance_of(Job).to receive(:save).and_return(false)
        allow_any_instance_of(Job).to receive(:errors).and_return(
          double(full_messages: [ 'Title cannot be blank' ])
        )

        expect { service_call }.not_to change(Job, :count)
      end
    end

    context 'with invalid language parametes' do
      let(:job_params) { {
        title: 'Software Engineer',
        hourly_salary: 20,
        language_codes: [ 'aa', 'de' ]
      } }

      it 'does not create a job' do
        expect { service_call }.not_to change(Job, :count)
      end

      it 'returns a failure status' do
        expect(service_call.success?).to be false
      end

      it 'populates the errors array with validation messages' do
        result = service_call
        expect(result.errors).not_to be_empty
      end

      it 'rolls back the transaction' do
        allow_any_instance_of(Job).to receive(:save).and_return(false)
        allow_any_instance_of(Job).to receive(:errors).and_return(
          double(full_messages: [ 'Title cannot be blank' ])
        )

        expect { service_call }.not_to change(Job, :count)
      end
    end
  end

  describe '#success?' do
    it 'returns true when errors are empty and job is present' do
      service = described_class.new(valid_job_params, user, company)
      service.call

      expect(service.success?).to be true
    end

    it 'returns false when errors are present' do
      service = described_class.new({}, user, company)
      service.call

      expect(service.success?).to be false
    end

    it 'returns false when job is not present' do
      service = described_class.new({}, user, company)
      allow(service).to receive(:errors).and_return([])
      allow(service).to receive(:job).and_return(nil)

      expect(service.success?).to be false
    end
  end
end
