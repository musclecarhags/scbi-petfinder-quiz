require 'rails_helper'

RSpec.describe Quiz do

  describe '.questions' do

    it 'should return an array of questions' do
      questions = described_class.questions
      expect(questions).to be_an Array
      expect(questions.first[:question]).to eq 'Would your ideal cat be independent?'
      expect(questions.first[:keywords]).to eq ['solo','loner','independent']
      expect(questions.first[:exclusions]).to eq ['outgoing','very social']
    end

  end

end
