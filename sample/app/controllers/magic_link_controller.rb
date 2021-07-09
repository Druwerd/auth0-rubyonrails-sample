class MagicLinkController < ApplicationController
  def new
  end

  def submit
    @email = params[:email]
    # generate a random value and store it in the user's session
    # we'll send the value as 'state' through the API
    # on redirect the 'state' value will be send in params
    # then we'll compare params['state'] and the value stored in the session
    password_less_state = SecureRandom.hex
    session[:password_less_state] = password_less_state
    auth0_client.start_passwordless_email_flow(
      @email,
      'link',
      {
        response_type: "code",
        redirect_uri: "http://127.0.0.1:3030/dashboard",
        scope: "openid profile email",
        state: password_less_state
      }
    )
  end

  private

  def auth0_client
    @auth0_client ||= Auth0Client.new(
      client_id: Rails.application.config.auth0[:auth0_client_id],
      client_secret: Rails.application.config.auth0[:auth0_client_secret],
      domain: Rails.application.config.auth0[:auth0_domain],
      api_version: 2,
      timeout: 15 # optional, defaults to 10
    )
  end
end
