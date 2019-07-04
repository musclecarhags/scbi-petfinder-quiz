class CatMatcher
    $x = 0
    $percent = Array.new
  def self.matches **args
    new( args ).matches
  end

  def initialize params:
    @params = params
  end

  def matches
    @matches ||= find_matches
  end

  def answers
    @answers ||= @params.collect { |k,v| v }
  end

  def find_matches
    adoptable_cats.select { |cat| matching_cat? cat }
  end

  def matching_cat? cat
    tags = cat['tags'].map(&:downcase)
    environment = cat['environment']
    matched_age = matching_ages.include? cat['age'].downcase

    if cat['name'].downcase.include? 'adopt'
      status_matched = false
    else
      status_matched = true
    end
    # Get the intersection of tags and matching keywords.
    # If there are matched keywords, this is a potential match.
    matched_tags = matching_keywords & tags
    match_found = matched_tags.length > 0
    $keywords = matching_keywords.uniq.sort
    $percent[$x] = matched_tags.length.to_f / $keywords.length.to_f * 100
    #puts matched_tags.length
    #puts $keywords.length
    #puts $percent[$x]
    $x = $x + 1

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
    match_found && !exclusion_found && environment_matched && matched_age && status_matched
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

  def matching_ages
      @matching_ages ||= answers
      .select { |a| a == "baby" || "young" || "adult" || "senior" }
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
    #$cats ||= CatFinder.adoptable_cats
  end
end
