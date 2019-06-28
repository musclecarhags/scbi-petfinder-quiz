require 'rails_helper'

RSpec.describe 'Cat Quiz', type: :request do

  describe 'GET quiz' do

    it 'renders a quiz form' do
      get '/'
      expect(response).to have_http_status :ok
      expect(response.body).to match /Would your ideal cat be independent\?/
    end

  end

  describe 'GET matches' do

    it 'renders quiz results' do
      VCR.use_cassette('cat_matches') do
        get '/cats?q0=yes&q1=no&q2=yes&q3=no&q4=yes&q5=yes&q6=yes&q7=no&q8=no&commit=Find+Cats'
        expect(response).to have_http_status :ok
        expect(response.body).to match /Thomas Too/
        expect(response.body).to match /Keke/
      end
    end

  end

end
