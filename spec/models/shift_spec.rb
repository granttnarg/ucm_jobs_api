require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'validations' do
    it "is valid with valid attributes" do
      shift = build(:shift)
      expect(shift).to be_valid
    end

    it "is invalid without a start_datetime" do
      shift = build(:shift, start_datetime: nil)
      expect(shift).not_to be_valid
      expect(shift.errors[:start_datetime]).to include("can't be blank")
    end

    it "is invalid without an end_datetime" do
      shift = build(:shift, end_datetime: nil)
      expect(shift).not_to be_valid
      expect(shift.errors[:end_datetime]).to include("can't be blank")
    end

    it "is invalid when end_datetime is before start_datetime" do
      shift = build(:shift, :invalid_timespan)
      expect(shift).not_to be_valid
      expect(shift.errors[:end_datetime]).to include("must be after start time")
    end
  end

  describe "time handling" do
    it "stores times in UTC" do
      shift = [ build(:shift,
                    start_datetime: Time.new(2025, 4, 5, 9, 0, 0, "+02:00"),
                    end_datetime: Time.new(2025, 4, 5, 13, 0, 0, "+02:00")) ]

      create(:job, shifts: shift)

      retrieved_shift = Shift.find(shift.first.id)

      expect(retrieved_shift.start_datetime.zone).to eq("UTC")
      expect(retrieved_shift.end_datetime.zone).to eq("UTC")

      expect(retrieved_shift.start_datetime.hour).to eq(7)
    end
  end

  describe '#shift_hours' do
  let(:shift) { build(:shift) }

  it 'calculates hours correctly' do
    shift.start_datetime = Time.zone.parse('2025-04-05 09:00:00')
    shift.end_datetime = Time.zone.parse('2025-04-05 17:30:00')
    expect(shift.shift_hours).to eq(8.5)
  end

  it 'handles overnight shifts' do
    shift.start_datetime = Time.zone.parse('2025-04-05 22:00:00')
    shift.end_datetime = Time.zone.parse('2025-04-06 06:00:00')
    expect(shift.shift_hours).to eq(8.0)
  end
end

describe '#earnings' do
  let(:job) { build(:job, hourly_salary: 25.50) }
  let(:shift) { build(:shift, job: job) }

  it 'calculates earnings correctly' do
    allow(shift).to receive(:shift_hours).and_return(8.5)
    expect(shift.earnings).to eq(216.75) # 8.5 * 25.50 = 216.75
  end
end
end
