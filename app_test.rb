require 'minitest/autorun'
require 'rack/test'
require_relative 'app'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_get_grants
    get '/api/v1/grants'
    assert last_response.ok?
    
    response_body = JSON.parse(last_response.body)
    assert_equal true, response_body['success']
    assert_operator response_body['data'].length, :>, 0
  end
end
