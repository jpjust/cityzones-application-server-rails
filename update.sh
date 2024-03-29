#!/bin/sh

echo "Updating app..."

git pull
git reset --hard
chown cityzones: Gemfile*
sudo -u cityzones bundle install
/opt/rbenv/shims/bundle exec rake assets:precompile db:migrate RAILS_ENV=production
chown -R www-data: *
touch tmp/restart.txt
#passenger-config restart-app $(pwd)

echo "Finished."
