require 'sidekiq'
require_relative './lib/application'

require 'sidekiq/web'
require 'sidekiq/cron/web'

run Sidekiq::Web