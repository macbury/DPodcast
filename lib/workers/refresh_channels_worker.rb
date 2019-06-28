class RefreshChannelsWorker
  include Sidekiq::Worker

  def perform
    feed['channels']&.each do |channel_id|
      SyncChannelWorker.perform_async(channel_id, nil)
    end

    feed['videos']&.each do |video_id|
      SyncChannelWorker.perform_async(nil, video_id)
    end
  end

  private

  def feed
    YAML.load_file(ENV.fetch('FEEDS_PATH'))
  end
end