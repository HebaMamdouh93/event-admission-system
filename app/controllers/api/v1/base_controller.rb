class Api::V1::BaseController < ApplicationController
  include ApiResponse
  before_action :authenticate_user!
end
