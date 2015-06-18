#!/bin/bash
export RAILS_ENV=production
cd /home/deploy/discourse-dev.rgadev.com/discourse
git pull
bundle update
bundle exec rake assets:precompile
sudo service nginx restart