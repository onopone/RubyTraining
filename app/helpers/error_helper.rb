require 'json'

module ErrorHelper
  def throwInternalServerError(response)
    begin
	   yield
    rescue
       response.status = 500
	   error_dic = Hash[ "message" , "unexpected error" ]
	   JSON.dump(error_dic)
       #return nil		#return nilはメソッドを呼び出した際も適用され、全体が落ちる
    end
  end 
end