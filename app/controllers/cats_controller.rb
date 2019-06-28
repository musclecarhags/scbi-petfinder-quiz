class CatsController < ApplicationController

  before_action :validate_answers, only: [:match]

  def match
    @title = "Petfinder Results"
    @matches = CatMatcher.matches params: cat_params
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
