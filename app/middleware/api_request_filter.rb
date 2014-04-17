class APIRequestFilter
  def initialize app
    @app = app # app 受け取る
  end
  def call env # Rackアプリの仕様通りで
    begin
	   @app.call(env)
	rescue
	   error_dic = Hash[ "message" , "unexpected error" ]
	   response = Rack::Response.new {|r|
       r.status = 500
       r["Content-Type"] = "application/json"
       r.write JSON.dump(error_dic)
       }
       response.finish
    end
  end
end