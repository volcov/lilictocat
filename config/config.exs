import Config

config :lilictocat, Lilictocat.Github, github_access_token: System.get_env("LILICTOCAT_TOKEN")
config :lilictocat, :github_api, Lilictocat.Github.API

import_config "#{Mix.env()}.exs"
