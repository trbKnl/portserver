# Portserver

In this repository you will find a backend for [port](https://github.com/eyra/port).
The main purpose of this repository is to provide the user with a basic backend that could be used to:

* play around with a backend for port
* deploy port using a database as a storage solution for donated data

This backend handles:

1. The serving of a port app (created by cloning or forking [port](https://github.com/eyra/port)), and tailoring it to your own needs)
2. The storage of donated data

## Features

Portserver provides 2 main features:

1. *A means to store donated data locally when developing* 

Donated data gets stored data locally when portserver is run in development mode. This allows for immediate inspection (your own) donated data so you can perform very small local data donation yourself.

2. *A means to store data encrypted in a postgresql database* 

Donated data will also get store encrypted (at rest) in a database (in development and in production mode). This is a generic solution that can be implemented anywhere: on-premise and in the cloud. A single admin account is created that is allowed to log in onto the server and can export all donated data.

## Installation

### Prerequisites

In order to build and/or run portserver (a Phoenix application) locally, you will need a few dependencies installed:

* the Erlang VM and the Elixir programming language. To install Elixir and Erlang, follow these [instruction](https://elixir-lang.org/install.html). They will be different depending on your operating system. You will also need the Elixir package manager (`hex`) as well. To install `hex` run `mix local.hex`.

* a PostgreSQL database. See for example [windows instructions](https://www.postgresql.org/download/windows/), [arch linux](https://wiki.archlinux.org/title/PostgreSQL) or [Mac OS X](https://wiki.postgresql.org/wiki/Homebrew). A postgresql user needs to be configured with username: postgres and password: postgres.

* [Nodejs](https://nodejs.org/en) and `npm` must be installed 

Make sure to install anything necessary for your system. Having dependencies installed in advance can prevent frustrating problems later on.

### Install portserver to run it locally

After dependencies are installed you can do:

```
git clone https://github.com/trbKnl/portserver.git

# Change directory to the newly created project 
cd portserver  

# Installs dependencies, initializes database, builds frontend (see mix.exs)
mix setup      
```

Start Phoenix endpoint with `mix phx.server`. 
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Install your own port instance

In order to include your own port instance with this server: 
change `"port": "github:trbKnl/port"` to `"port": "github:<your-repo>/<your-clone-of-port>" in `/assets/package.json`.

If you already installed the dependencies don't forget to build the frontend again (in `/assets/` run `npm install`).

## Running port

If the installation went well, you should be greeted with the Phoenix startscreen served at "/"

### Routes

| URL | Description |
| --- | ----------- |
| `/` | Hosts the standard Phoenix welcome page. Change it if you so desire. |
| `/port/<participant-id>` | Your port app should be running at `/port/<participant-id>`. `<participant-id>` can be any alpha numeric string. |
| `/admins/login_in` | Port is configured with a single admin account. In development you can log in with email: `admin@admin.com` with password: `passwordpassword`. |

## Portserver architecture

In the figure you can see the portserver architecture.

<img width="600px" title="Portserver architecture" src="/resources/portserver_arch.svg">

1. Port is served to the participant and runs locally in the device of the participant
2. Participant decides to donate, data gets send back to the server
3. Data gets stored in encrypted at rest in a PostgreSQL database. If run in development mode the data is also stored in a folder `./donated_data`.
4. The research can log in using the admin account and can export all donated data


# Portserver in a Docker container

| Variable | Descrition |
|---|---|
| DB_NAME | Name of the postgresql database |
| DB_HOST | Location of the database (hostname) |
| DB_USER | Database username |
| DB_PASSWORD | Database password |
| SECRET_KEY_BASE | 64-bit long sequence |
| CLOAK_KEY | Encryption key for donated data if it ends ups in the database |
| PHX_HOST | Hostname |
| PHX_SERVER | Start the app with the server, set to true |
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
    -e PHX_SERVER=true \
    -e PORT=8000 \
    -e CLOAK_KEY="ljpT3WuKUDPlW36HqdJr8I4yYnDtsteTTzjTNacTWFg=" \
    -e ADMIN_PASSWORD="passwordpassword" \
    -e ADMIN_EMAIL="admin@admin.com" \
    portserver-test:latest
```
