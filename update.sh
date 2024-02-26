#!/bin/sh

echo "Updating app..."

git pull
git reset --hard
#bundle install
/opt/rbenv/shims/bundle exec rake assets:precompile db:migrate RAILS_ENV=production
touch tmp/restart.txt
#passenger-config restart-app $(pwd)

echo "Finished."
