class SyncChannelWorker
  include Sidekiq::Worker

  def perform(channel_id, video_id)
    DistributePodcast.new.call(channel_id: channel_id, video_id: video_id)
  end
end