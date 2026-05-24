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

  def test_get_grant_by_id
    get '/api/v1/grants/g_101'
    assert last_response.ok?

    response_body = JSON.parse(last_response.body)
    assert_equal true, response_body['success']
    assert_equal 'g_101', response_body['data']['id']
    assert_equal 'Global Community Impact Fund 2026', response_body['data']['title']
  end
end

