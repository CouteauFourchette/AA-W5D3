require 'json'

class Flash

  def initialize(req)
    cookies = req.cookies["_rails_lite_app"]
    if cookies
      @params = JSON.parse(cookies)
    else
      @params = Hash.new
    end
  end

  def [](key)
    @params[key]
  end

  def []=(key, val)
    @params[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    result = @params.to_json if @params
    res.set_cookie('_rails_lite_app', result)
    
  end
end
