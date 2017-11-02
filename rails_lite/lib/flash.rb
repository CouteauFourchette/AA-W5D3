require 'json'

class Flash

  def initialize(req)
    cookies = req.cookies["_rails_lite_app_flash"]
    @params = Hash.new
    @params['temp'] = Hash.new
    if cookies
      par = JSON.parse(cookies)
      par.delete('temp')
      @params['temp'] = par
    end

  end

  def [](key)
    if @params['temp']
      merged = @params['temp']
      @params.each { |k,v| merged[k] = v unless k=='temp' }
    else
      merged = @params['stay']
    end
    merged[key.to_s]
  end

  def []=(key, val)
    @params[key.to_s] = val
  end

  def now
    @params['temp']
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_flash(res)
    result = @params.to_json if @params
    res.set_cookie('_rails_lite_app_flash', result)
  end
end
