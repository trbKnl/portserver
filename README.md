# Portserver

In this repository you will find a backend for [port](https://github.com/eyra/port) version 1 as used in the port-pilot.
The main purpose of this repository is to provide the user with a basic backend that could be used to:

* Have a simple and basic means to deploy port v1 if the need ever arises
* Play around with a backend for port
* Have a testing backend for Port

This backend handles:

1. The serving of a Port app (created by cloning or forking [port](https://github.com/eyra/port)), and tailoring it to your own needs)
2. The storage of donated data


## Features

Portserver provides 2 main features:

1. *A means to store donated data locally when developing* 

Donated data gets stored data locally when portserver is run in development mode. This allows for immediate inspection (your own) donated data so you can perform very small local data donation yourself.

2. *A means to store data somewhere else when in production

** Database **

Donated data can be store encrypted (at rest) in a database. This is a generic solution that can be implemented anywhere: on-premise and in the cloud. A single admin account is created that is allowed to log in onto the server and can export all donated data.

In the figure below you can see a diagram of this solution.

<img width="600px" title="Portserver architecture" src="/resources/portserver_arch.svg">

1. Port is served and runs locally in the device of the participant
2. If the participant decides to donate data gets send back to the server
3. Data gets stored in encrypted at rest in a PostgreSQL database. If run in development mode the data is also stored in a folder `./donated_data`.
4. The researcher can log in using the admin account and can export all donated data

** Yoda **

Donated data can be send to Yoda

** Azure **

Donated data can be send to an Azure Storage account

## Installation

### Prerequisites

In order to build and/or run portserver (a Phoenix application) locally, you will need a few dependencies installed:

* the Erlang VM and the Elixir programming language. To install Elixir and Erlang, follow these [instruction](https://elixir-lang.org/install.html). They will be different depending on your operating system. You will also need the Elixir package manager (`hex`) as well. To install `hex` run `mix local.hex`.

* a PostgreSQL database. See for example [windows instructions](https://www.postgresql.org/download/windows/), [arch linux](https://wiki.archlinux.org/title/PostgreSQL) or [Mac OS X](https://wiki.postgresql.org/wiki/Homebrew). A postgresql user needs to be configured with username: postgres and password: postgres.

* [Nodejs](https://nodejs.org/en) and `npm` must be installed 

Make sure to install anything necessary for your system. Having dependencies installed in advance can prevent frustrating problems later on.

### Install portserver to run it locally

After the prerequisites are installed, run:

```
git clone https://github.com/trbKnl/portserver.git

# Change directory to the newly created project 
cd portserver  

# Installs dependencies, initializes database, builds frontend (see mix.exs)
mix setup      
```

### Install your own instance of port

In order to include your own port instance with this server: 
change `"port": "github:trbKnl/port"` to `"port": "github:<your-repo>/<your-clone-of-port>"` in `./assets/package.json`.

Don't forget to build the frontend again (in `./assets` run `npm install`).

### Start portserver

Start Phoenix endpoint with `mix phx.server`. 
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Start portserver with `mix phx.server`. If the installation went well, you should be greeted with the Phoenix welcome screen served at "/"

## Running portserver

### Routes

Portserver provides the following routes:

| URL | Description |
| --- | ----------- |
| `/` | Hosts the standard Phoenix welcome page. Change it to something else if you want. |
| `/port/<participant-id>` | Your port app should be running at `/port/<participant-id>`. `<participant-id>` can be any alpha numeric string. |
| `/admins/login_in` | Port is configured with a single admin account. In development you can log in with email: `admin@admin.com` with password: `passwordpassword`. |
| `/admin` | The admin panel where you can export donated data |

## Running portserver in production

This is untested and not recommended but it should function, and it might be used in the future.

### Portserver Docker example

When run in production portserver needs to be configured this is done using environmental variables.
The following environmental variables need to be set:

| Variable | Descrition |
|---|---|
| DB_NAME | Name of the Postgresql database |
| DB_HOST | Location of the database (hostname or domain) |
| DB_USER | Database username |
| DB_PASS | Database password |
| SECRET_KEY_BASE | a sequence of characters of length 65, this sequence is used by Phoenix to encrypt cookies |
| CLOAK_KEY | a sequence of characters of length 32, this is the encryption key that encrypts donated data at rest |
| PHX_HOST | Domain name of the server |
| PHX_SERVER | Start the app with the server. Set to "true". |
| PORT | Port the app is listening on |
| ADMIN_EMAIL | email address of the admin, this is used to log in to the admin panel |
| ADMIN_PASSWORD | password of the admin, this is used to log in to the admin panel |

### Portserver as a container

This repository includes a Dockerfile, which can be used to package portserver as a container. 
See the Dockerfile for the details.

Below is an example a `docker run` command to start a portserver container called `portserver-test:latest`. 
This example shows how the environmental variables could be set.
This specific command runs a docker container locally, with a Postgresql database also running locally.
This example assumes that the Postgresql is already configured (which would also most likely be the case in a production environment).

```
docker run \
    -p 8000:8000 \
    -e DB_NAME=dockertest \
    -e DB_HOST=172.17.0.1 \
    -e DB_USER=postgres \
    -e DB_PASS=postgres \
    -e SECRET_KEY_BASE=aUMZobj7oJn58XIlMGVcwTYrCsAllwDCGlwDCGlwDCGwDChdhsjahdghaggdgdGt7MoQYJtJbA= \
    -e PHX_HOST=localhost \
    -e PHX_SERVER=true \
    -e PORT=8000 \
    -e CLOAK_KEY="ljpT3WuKUDPlW36HqdJr8I4yYnDtsteTTzjTNacTWFg=" \
    -e ADMIN_PASSWORD="passwordpassword" \
    -e ADMIN_EMAIL="admin@admin.com" \
    portserver-test:latest
```

