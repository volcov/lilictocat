import Config

config :lilictocat, Lilictocat.Github, github_access_token: System.get_env("LILICTOCAT_TOKEN")
config :lilictocat, :github_api, Lilictocat.Github.API
config :tentacat, :deserialization_options, keys: :atoms

import_config "#{Mix.env()}.exs"
