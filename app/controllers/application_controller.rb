class ApplicationController < ActionController::API
  include Response
  include TheaterMapper
  include MovieMapper
end
