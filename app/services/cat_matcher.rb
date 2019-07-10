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

  def answers
    @answers ||= @params.collect { |k,v| v }
  end

  def find_matches
    adoptable_cats.select { |cat| matching_cat? cat }
  end

  def matching_cat? cat
    tags = cat['tags'].map(&:downcase)
    environment = cat['environment']
    age = cat['age'].downcase

    if matching_ages.any? age
      matched_age = true
    else
      matched_age = false
    end

    if cat['name'].downcase.include? 'adopt'
      status_matched = false
    else
      status_matched = true
    end
    # for each keyword, checking if the tag is included in the keyword

    matched_tags = tags.select do |tag|
      final_keywords.any? {|k| tag.include? k}
    end

    match_found = matched_tags.length > 0

    cat['percent'] = matched_tags.length.to_f / tags.length.to_f * 100

    exclude = false

    # Get the intersection of tags and exclusion keywords.
    # If there are matched exclusions, this cannot be a match.
    excluded_tags = tags.select do |tag|
      exclusion_keywords.any? {|k| tag.include? k}
    end

    if excluded_tags.length > 0
      exclude = true
    end

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
    match_found && environment_matched && matched_age && status_matched && !exclude
  end

def quiz_answers
    @quiz_answers ||= quiz_questions
      .zip( answers )
      .collect { |q,a| q }
end

def yes_answers
  @yes_answers ||= quiz_questions
    .zip( answers )
    .select { |q,a| a == "yes" }
    .collect { |q,a| q }
  end

def matching_environment
  @matching_environment ||= yes_answers
    .collect { |q| (q[:environment] || []).map(&:downcase)}.flatten.compact || [] & ages
end

def matching_keywords
  @matching_keywords ||= yes_answers
    .collect { |q| (q[:keywords] || []).map(&:downcase)}.flatten.compact || []
end

def matching_ages
  ages = ['baby', 'young', 'adult', 'senior']
  @matching_ages = quiz_answers & ages
end

def exclusion_keywords
  @exclusion_keywords ||= yes_answers
    .collect { |q| (q[:exclusions] || []).map(&:downcase)}.flatten.compact || []
end

def quiz_questions
  @quiz_questions ||= Quiz.questions
end

def adoptable_cats
  @adoptable_cats ||= CatFinder.animals
end

def final_keywords
  @final_keywords ||= matching_keywords - keyword_intersection
end

def keyword_intersection
  @keyword_intersection = matching_keywords & exclusion_keywords
end
end
