# Portserver

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Notes: deviations from Next

  * Added: phx-update="ignore" in React component 
  * Upgraded to webpack 5 with changed bare minimum build config
  * Changed `port.js` to handle new sytnax for webworkers
  * Configured Plug.Static differently 


# Set ennvironment variables

| Variable | Descrition |
|---|---|
| DB_NAME | name of the postgresql database |
| DB_HOST | location of the database |
| DB_USER | database username |
| DB_PASSWORD | database password |
| SECRET_KEY_BASE | 64-bit long sequence |
| PHX_HOST | location of the host  |
| PORT | port number the app is listening on |
| CLOAK_KEY | encryption key for donated data if it ends ups in the database |

```
docker run \
    -p 8000:8000
    -e DB_NAME=dockertest \
    -e DB_HOST=172.17.0.1 \
    -e DB_USER=postgres \
    -e DB_PASSWORD=postgres \
    -e SECRET_KEY_BASE=aUMZobj7oJn58XIlMGVcwTYrCsAllwDCGlwDCGlwDCGwDChdhsjahdghaggdgdGt7MoQYJtJbA= \
    -e PHX_HOST=localhost \
    -e PORT=8000 \
    -e CLOAK_KEY="ljpT3WuKUDPlW36HqdJr8I4yYnDtsteTTzjTNacTWFg=" \
    Portserver-test:latest
```
