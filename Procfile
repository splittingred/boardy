bot: bundle exec bin/bot
resque: COUNT=3 QUEUE=* bundle exec rake resque:work
scheduler: bundle exec rake environment resque:scheduler
