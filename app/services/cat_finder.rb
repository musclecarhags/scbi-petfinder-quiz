class CatFinder

  include HTTParty
  base_uri 'api.petfinder.com/v2'

  def initialize
    @access_token = request_access_token
  end

  def self.animals
    new.animals
  end

  def animals
    @animals ||= request_animals
  end

  def auth_headers
    @auth_headers ||= { "Authorization": "Bearer #{@access_token}" }
  end

  def client_id
    @client_id ||= Rails.application.credentials.petfinder[:client_id]
  end

  def client_secret
    @client_secret ||= Rails.application.credentials.petfinder[:client_secret]
  end

  def organization
    @organization ||= Settings.petfinder.organization
  end

  def request_access_token
    body = {
      grant_type:    'client_credentials',
      client_id:     client_id,
      client_secret: client_secret
    }
    response = self.class.post '/oauth2/token', body: body
    response_json = JSON.parse response.body
    response_json['access_token']
  end

  def request_animals
    parsed_response = request_animal_page
    total_pages = parsed_response['pagination']['total_pages']

    all_animals = parsed_response['animals']
    2.upto(total_pages) do |page|
      parsed_response = request_animal_page page: page
      all_animals += parsed_response['animals']
    end

    all_animals
  end

  def request_animal_page page: 1
    response = self.class.get(
      "/animals",
      headers: auth_headers,
      query: { organization: organization, status: 'adoptable', page: page }
    )
    JSON.parse( response.body )
  end

end
