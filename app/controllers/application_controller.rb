class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "Greetings from RubyGram!"
  end
end
