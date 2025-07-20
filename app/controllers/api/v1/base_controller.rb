class Api::V1::BaseController < ApplicationController
  include ExceptionHandler
  before_action :authenticate_user!
end
