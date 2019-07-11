class CatsController < ApplicationController

  before_action :validate_answers, only: [:match]

  def match
    @title = "Petfinder Results"
    cat_matcher = CatMatcher.new params: cat_params
    @matches = cat_matcher.matches.sort_by {|cat| cat['percent']}.reverse
    @keywords = cat_matcher.final_keywords.uniq.sort
    @exclude_keywords = cat_matcher.exclusion_keywords.uniq.sort
    @ages = cat_matcher.matching_ages.join ', '
    puts cat_matcher.matching_ages.join ', '
  end

  def quiz
    @title = "Petfinder Quiz"
    @quiz = Quiz.new
  end

  private

  def cat_params
    request.parameters.select { |k,v| k =~ /q\d+/ }
  end

  def validate_answers
    if cat_params.length < Quiz.questions.length
      flash[:error] = "Please fill out all questions to find your next cat!"
      redirect_to '/'
    end
  end
end
