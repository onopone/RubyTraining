require 'rack/camel_snake'
require 'rack/server_errors'
require_relative '../spec_helper'

describe 'Integration Test' do
  let(:snake_expected){ { 'is_done' => true, 'order' => 1, 'task_title' => 'hoge' } }
  let(:camel_expected){ { 'isDone' => true, 'order' => 1, 'taskTitle' => 'hoge' }   }

  def post_todo(body)
    post '/api/todos', JSON.dump(body), 'CONTENT_TYPE' => 'application/json'
  end

  before do
    post_todo(camel_expected)
  end

  include Rack::Test::Methods

  def app
    @app ||= Rack::ServerErrors.new(Rack::CamelSnake.new(Mosscow))
  end

  context 'GET /api/todos' do
    it 'returns 200' do
      get '/api/todos'
      last_response.status.should eq 200
    end
  end

  context 'POST /api/todos' do
    it 'returns 201' do
      post_todo(camel_expected)

      last_response.status.should eq 201
      JSON.parse(last_response.body).should include camel_expected
    end
  end

  context 'PUT /api/todos/:id' do
    let(:updated){ { 'isDone' => false, 'order' => 1, 'taskTitle' => 'moge' } }
    it 'returns 204' do
      put '/api/todos/1', JSON.dump(updated), 'CONTENT_TYPE' => 'application/json'

      JSON.parse(last_response.body).should include updated
    end
  end

  context 'DELETE /api/todos' do
    it 'returns 204' do
      post_todo(camel_expected)

      delete '/api/todos/2'
      last_response.status.should eq 204
    end
  end

  context 'GET /error' do
    let(:expected){ { 'message' => 'unexpected error' } }
    it 'returns 500' do
      get '/error'

      last_response.status.should eq 500
      JSON.parse(last_response.body).should eq expected
    end
  end

end