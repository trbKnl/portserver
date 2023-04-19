#!/bin/sh

# Initialize database schema's
/app/bin/portserver eval "Portserver.Release.migrate"

# Start server
/app/bin/portserver start
