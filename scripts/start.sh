#!/bin/sh

# Initialize database schema's
/app/bin/migrate

# Start server
/app/bin/server
