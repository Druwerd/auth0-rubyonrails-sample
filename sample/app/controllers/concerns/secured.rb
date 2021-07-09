module Secured
  extend ActiveSupport::Concern

  included do
    before_action :check_magic_link_state
    before_action :logged_in_using_omniauth?
  end

  def logged_in_using_omniauth?
    redirect_to '/auth/redirect/' unless session[:userinfo].present?
  end

  def check_magic_link_state
    return if session[:userinfo].present? # already logged in
    Rails.logger.info("PARAMS STATE: #{params[:state]}")
    Rails.logger.info("SESSION STATE: #{session['password_less_state']}")

    if session["password_less_state"].blank?
      redirect_to '/auth/failure'
      return
    end

    if session["password_less_state"] != params[:state]
      redirect_to '/auth/failure'
      return
    end

    Rails.logger.info("PASSED MAGIC LINK CHECK")
  end
end
