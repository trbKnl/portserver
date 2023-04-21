# Portserver

In this repository you will find a backend for (port)[https://github.com/eyra/port]. 
The main purpose of this repository is to provide the user with a basic backend that could be used to 
to deploy port. 

This backend handles:

1. The serving of a `port` app (created by forking (`port`)[https://github.com/eyra/port], and tailoring to your own needs)
2. Handles the storing of the data

## Features

This backend provides:

1. Donated data gets stored data locally when run in development mode. This allows for immediate inspection (your own) donated data so you can perform very small local data donation yourself.
2. Donated data gets store encrypted (at rest) in a database. This is a generic solution that can be implemented anywhere: on-premise and in the cloud. A single admin account is created that is allowed to log in onto the server and can export all donated data.


To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Portserver architecture

<img title="Portserver architecture" src="/resources/portserver_arch">

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

# Set ennvironment variables

| Variable | Descrition |
|---|---|
| DB_NAME | Name of the postgresql database |
| DB_HOST | Location of the database (hostname) |
| DB_USER | Database username |
| DB_PASSWORD | Database password |
| SECRET_KEY_BASE | 64-bit long sequence |
| CLOAK_KEY | Encryption key for donated data if it ends ups in the database |
| PHX_HOST | Hostname |
| PORT | Port the app is listening on |
| ADMIN_EMAIL | email address of the admin |
| ADMIN_PASSWORD | password of the admin |

```
docker run \
    -p 8000:8000 \
    -e DB_NAME=dockertest \
    -e DB_HOST=172.17.0.1 \
    -e DB_USER=postgres \
    -e DB_PASSWORD=postgres \
    -e SECRET_KEY_BASE=aUMZobj7oJn58XIlMGVcwTYrCsAllwDCGlwDCGlwDCGwDChdhsjahdghaggdgdGt7MoQYJtJbA= \
    -e PHX_HOST=localhost \
    -e PORT=8000 \
    -e CLOAK_KEY="ljpT3WuKUDPlW36HqdJr8I4yYnDtsteTTzjTNacTWFg=" \
    -e ADMIN_PASSWORD="passwordpassword" \
    -e ADMIN_EMAIL="admin@admin.com" \
    portserver-test:latest
```
