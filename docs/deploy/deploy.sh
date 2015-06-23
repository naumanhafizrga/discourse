#!/bin/bash
cd /home/deploy/discourse-dev.rgadev.com/discourse
bluepill stop --no-privileged
bluepill quit --no-privileged
git pull
bundle install --without test --deployment
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake db:migrate
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake assets:precompile
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ROOT=/home/deploy/discourse-dev.rgadev.com/discourse RAILS_ENV=production NUM_WEBS=2 /home/deploy/.rvm/bin/bootup_bluepill --no-privileged -c ~/.bluepill load /home/deploy/discourse-dev.rgadev.com/discourse/config/discourse.pill
sudo service nginx restart