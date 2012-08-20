class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_time_zone

  def set_time_zone
    Time.zone = 'Beijing'
  end

  def after_sign_in_path_for(resource_or_scope)
    root_path
  end

end
