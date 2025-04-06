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

  describe '#total_earnings' do
    context 'with multiple shifts' do
      before do
        job = build(:job, title: "3 shift job", hourly_salary: 20.0)

         # shift from factory 1hour at 20.0ph

         shift_1 = create(:shift,
          job: job,
          start_datetime: Time.zone.parse('2050-04-05 23:00:00'),
          end_datetime: Time.zone.parse('2050-04-06 2:00:00')
        ) # 3 hours

        shift_2 = create(:shift,
          job: job,
          start_datetime: Time.zone.parse('2050-04-06 10:00:00'),
          end_datetime: Time.zone.parse('2050-04-06 11:00:00')
        ) # 1 hours

        shift_3 = create(:shift,
          job: job,
          start_datetime: Time.zone.parse('2050-04-07 13:00:00'),
          end_datetime: Time.zone.parse('2050-04-07 15:00:00')
        ) # 2 hours

        job.shifts << [ shift_1, shift_2, shift_3 ]
        job.save
      end

      it 'calculates the sum of all shift earnings' do
        # 7 hours
        # 7 hours * $20/hour = $140
        expect(Job.find_by(title: "3 shift job").total_earnings).to eq(140.00)
      end
    end
  end
end
