#!/bin/sh

# Initialize database schema's
# create admin user
/app/bin/portserver eval "Portserver.Release.migrate"

# Start server
/app/bin/portserver start
