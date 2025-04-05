RSpec.describe 'API V1 Languages API', type: :request do
  # Create languages to use in tests
  let!(:languages) { create_list(:language, 3) }

  path '/api/v1/languages' do
    get 'Lists all languages' do
      tags 'Languages'
      produces 'application/json'

      response '200', 'languages found' do
        schema type: :object,
          properties: {
            languages: {
              type: :array,
              items: { '$ref' => '#/components/schemas/language' }
            },
            meta: {
              type: :object,
              properties: {
                total_count: { type: :integer }
              }
            }
          },
          required: [ :languages ]

        run_test! do |response|
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['languages'].size).to eq(Language.count)
        end
      end
    end
  end
end
