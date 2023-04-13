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


| SECRET_KEY_BASE |
| DB_USER |
| DB_PASSWORD |
| DB_HOST |
| DB_NAME |
