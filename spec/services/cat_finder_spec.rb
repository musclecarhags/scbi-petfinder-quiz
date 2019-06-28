require 'rails_helper'

RSpec.describe CatFinder do

  describe '.adoptable_cats' do

    let(:adoptable_cats) { described_class.adoptable_cats }
    let(:types) do
      adoptable_cats.collect { |cat| cat['type'] }.uniq
    end
    let(:statuses) do
      adoptable_cats.collect { |cat| cat['status'] }.uniq
    end
    let(:organizations) do
      adoptable_cats.collect { |cat| cat['organization_id'] }.uniq
    end

    it 'retrieves adoptable cats from PA16' do
      VCR.use_cassette('adoptable_cats') do
        expect( adoptable_cats ).to be_present
        expect( adoptable_cats.length ).to eq 12
        expect( types ).to contain_exactly 'Cat'
        expect( statuses ).to contain_exactly 'adoptable'
        expect( organizations ).to contain_exactly 'PA16'
      end
    end

  end

end
