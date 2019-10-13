class MessageAuth < Rack::Auth::Basic
  def call(env)
    request = Rack::Request.new(env)

    if request.path =~ /\/message\//
      super # perform auth
    else
      @app.call(env) # skip auth
    end
  end
end

use MessageAuth, "login" do |username, password|
  [username, password] == [ENV['authentication_login'], ENV['authentication_password']]
end
