defmodule Google do
  @moduledoc """
  An OAuth2 strategy for Google.
  Based on the OAuth2 strategy for GitHub by Sonny Scroggin
  in https://github.com/scrogson/oauth2_example
  """
  # Attribution: http://wsmoak.net/tag/fitbit.html
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

  # Public API

  def new do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      redirect_uri: System.get_env("REDIRECT_URI"),
      site: "https://www.googleapis.com/",
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url: "https://oauth2.googleapis.com/token"
    ])
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(new(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(new(), params)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> put_header("Authorization", "Basic " <> Base.encode64( System.get_env("CLIENT_ID") <> ":" <> System.get_env("CLIENT_SECRET")))
    |> AuthCode.get_token(params, headers)
  end
end
