require 'rails_helper'

RSpec.describe Jobs::Search::Service, type: :service do
  let!(:english) { create(:language, name: 'English', code: 'en') }
  let!(:german) { create(:language, name: 'German', code: 'de') }
  let!(:spanish) { create(:language, name: 'Spanish', code: 'es') }

  let!(:company) { create(:company) }

  let!(:job1) do
    job = create(:job, title: 'Software Engineer', company: company)
    job.languages << english
    job.languages << german
    job
  end

  let!(:job2) do
    job = create(:job, title: 'DevOps Engineer', company: company)
    job.languages << english
    job
  end

  let!(:job3) do
    job = create(:job, title: 'Product Manager', company: company)
    job.languages << spanish
    job
  end

  describe '.search' do
    context 'when searching by title' do
      it 'returns jobs matching the title' do
        results = described_class.search(title: 'Engineer')
        expect(results).to include(job1, job2)
        expect(results).not_to include(job3)
      end

      it 'is case insensitive' do
        results = described_class.search(title: 'engineer')
        expect(results).to include(job1, job2)
      end

      it 'returns all jobs when no title is provided' do
        results = described_class.search({})
        expect(results).to include(job1, job2, job3)
      end
    end

    context 'when searching by language' do
      it 'returns jobs matching a single language' do
        results = described_class.search(language_codes: 'en')
        expect(results).to include(job1, job2)
        expect(results).not_to include(job3)
      end

      it 'returns jobs matching multiple languages' do
        results = described_class.search(language_codes: [ 'en', 'de' ])
        expect(results).to include(job1)
        expect(results).not_to include(job2, job3)
      end

      it 'returns jobs matching language when codes are in an array' do
        results = described_class.search(language_codes: [ 'es' ])
        expect(results).to include(job3)
        expect(results).not_to include(job1, job2)
      end
    end

    context 'when searching by both title and language' do
      it 'returns jobs matching both criteria' do
        results = described_class.search(title: 'Engineer', language_codes: 'en')
        expect(results).to include(job1, job2)
        expect(results).not_to include(job3)
      end

      it 'returns no jobs when criteria don\'t match' do
        results = described_class.search(title: 'Engineer', language_codes: 'es')
        expect(results).to be_empty
      end
    end
  end
end
