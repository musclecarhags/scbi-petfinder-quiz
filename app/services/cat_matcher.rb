class CatMatcher

  def self.matches **args
    new( args ).matches
  end

  def initialize params:
    @params = params
  end

  def matches
    @matches ||= find_matches
  end

  private

  def answers
    @answers ||= @params.collect { |k,v| v }
  end

  def find_matches
    adoptable_cats.select { |cat| matching_cat? cat }
  end

  def matching_cat? cat
    tags = cat['tags'].map(&:downcase)
    environment = cat['environment']

    # Get the intersection of tags and matching keywords.
    # If there are matched keywords, this is a potential match.
    matched_tags = tags & matching_keywords
    match_found = matched_tags.length > 0

    # Get the intersection of tags and exclusion keywords.
    # If there are matched exclusions, this cannot be a match.
    excluded_tags = tags & exclusion_keywords
    exclusion_found = excluded_tags.length > 0

    # Match with environment if attributes are present
    environment_matched = true
    if matching_environment.include? 'children'
      environment_matched &= cat['environment']['children']
    end
    if matching_environment.include? 'dogs'
      environment_matched &= cat['environment']['dogs']
    end
    if matching_environment.include? 'cats'
      environment_matched &= cat['environment']['cats']
    end

    match_found && !exclusion_found && environment_matched
  end

  def matching_questions
    @matching_questions ||= quiz_questions
      .zip( answers )
      .select { |q,a| a == "yes" }
      .collect { |q,a| q }
  end

  def matching_environment
    @matching_environment ||= matching_questions
      .collect { |q| q[:environment] }.flatten.compact || []
  end

  def matching_keywords
    @matching_keywords ||= matching_questions
      .collect { |q| q[:keywords] }.flatten.compact || []
  end

  def exclusion_keywords
    @exclusion_keywords ||= matching_questions
      .collect { |q| q[:exclusions] }.flatten.compact || []
  end

  def quiz_questions
    @quiz_questions ||= Quiz.questions
  end

  def adoptable_cats
    @adoptable_cats ||= CatFinder.adoptable_cats
  end

end
