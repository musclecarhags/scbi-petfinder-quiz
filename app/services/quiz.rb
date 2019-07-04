class Quiz

  def self.questions
    new.questions
  end

  def questions
    @questions ||= gather_questions
  end

  private

  def gather_questions
    [
      {
        question: 'Would your ideal cat be active such as running around the house entertaining you with their antics?',
        keywords: ['energetic','active','fun','happy'],
        exclusions: ['calm','relaxed','peaceful','gentle','manner']
      },
      {
        question: 'Would your ideal cat like to play with toys?',
        keywords: ['playful','fun','curious','happy']
      },
      {
        question: 'Would your ideal cat be affectionate such as by nuzzling you with their head?',
        keywords: ['affectionate','loving','sweet','kiss','friendly','outgoing','happy', 'precious', 'petting']
      },
      {
        question: 'Would your ideal cat like to lay with you or sleep in your bed?',
        keywords: ['snuggle','snuggler', 'snuggly', 'cuddle', 'cuddly', 'affectionate','calm','manner', 'laid back']
      },
      {
        question: 'Would your ideal cat like to follow you around?',
        keywords: ['friendly','social','loyal','curious']
      },
        {
        question:   'Would your ideal cat be independent and keep to themselves unless engaged?',
        keywords:   ['solo','loner','independent','low key'],
        exclusions: ['outgoing','very social']
      },
      {
        question: 'Do you have or want children?',
        environment: ['children']
      },
      {
        question: 'Do you have other cat(s) or want another cat(s)?',
        environment: ['cats']
      },
      {
        question: 'Do you have or want a dog/have dogs?',
        environment: ['dogs']
      },
      {
      question: '',
      age: ['baby']
      },
      {
      question: '',
      age: ['young']
      },
      {
      question: '',
      age: ['adult']
      },
      {
      question: '',
      age: ['senior']
      }
    ]
  end

end
