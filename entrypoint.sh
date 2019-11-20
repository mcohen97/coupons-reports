#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /application/tmp/pids/server.pid

rails RAILS_ENV=production db:migrate db:seed

WORKERS=CreatedPromotionsWorker,EvaluatedPromotionsWorker rake sneakers:run & disown

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"