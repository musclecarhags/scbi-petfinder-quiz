class CatFinder

  include HTTParty
  base_uri 'api.petfinder.com/v2'

  def self.adoptable_cats
    new.adoptable_cats
  end

  def initialize
    @access_token = request_access_token
  end

  def adoptable_cats
    animals.select { |animal| adoptable_cat? animal }
  end

  private

  def adoptable_cat? animal
    animal['type'] == 'Cat' && animal['status'] == 'adoptable'
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
    response = self.class.get(
      "/animals",
      headers: auth_headers,
      query: { organization: organization }
    )
    JSON.parse( response.body )['animals']
  end

end
