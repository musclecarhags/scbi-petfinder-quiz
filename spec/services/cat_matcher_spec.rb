require 'rails_helper'

RSpec.describe CatMatcher do

  describe '.matches' do

    let(:quiz_results) do
      {
        q1: 'yes',
        q2: 'no',
        q3: 'yes',
        q4: 'no',
        q5: 'yes',
        q6: 'yes',
        q7: 'yes',
        q8: 'no',
        q9: 'no'
      }
    end
    let(:matches) { described_class.matches params: quiz_results }

    it 'should find cat matches based on quiz results' do
      VCR.use_cassette('cat_matches') do
        expect(matches).to be_present
        expect(matches.first['name']).to eq 'Thomas Too'
        expect(matches.last['breeds']['primary']).to eq 'Domestic Short Hair'
      end
    end

  end

end
