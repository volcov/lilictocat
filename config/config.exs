import Config

config :lilictocat, :github_access_token, "token"
config :lilictocat, :github_api, Lilictocat.Github.API
config :tentacat, :deserialization_options, keys: :atoms

import_config "#{Mix.env()}.exs"
