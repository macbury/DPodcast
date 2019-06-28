require 'rubygems'
require 'bundler/setup'
require 'dotenv/load'
require 'sidekiq-cron'
require 'sidekiq'

require_relative './storage'
require_relative './transactions'
require_relative './transactions/distribute_podcast'
require_relative './workers/refresh_channels_worker'
require_relative './workers/sync_channel_worker'
require_relative './workers/refresh_ipns_worker'
require_relative './workers/ping_gateway_worker'
require_relative './workers/propagate_gateways_worker'

REDIS_URL = ENV.fetch('REDIS_URL')

Sidekiq.configure_server do |config|
  job_count = ENV.fetch('SIDEKIQ_CONCURRENCY', 5).to_i

  config.redis = ConnectionPool.new(size: [job_count + 5, 15].max, timeout: 5) do 
    Redis.new(url: REDIS_URL)
  end

  Sidekiq::Cron::Job.create(name: 'Refresh channels', cron: '0 */3 * * *', class: 'RefreshChannelsWorker')
  Sidekiq::Cron::Job.create(name: 'Refresh ipns', cron: '0 * * * *', class: 'RefreshIpnsWorker')
  Sidekiq::Cron::Job.create(name: 'Propagate gateways', cron: '0 * * * *', class: 'PropagateGatewaysWorker')
end

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL }
end

Yt.configure do |config|
  config.log_level = :debug
  config.api_key = ENV.fetch('YOUTUBE_API_KEY')                                                     
end
