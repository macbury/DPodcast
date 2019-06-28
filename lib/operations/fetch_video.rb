require 'dry/transaction/operation'
require 'yt'

class FetchVideo
  include Dry::Transaction::Operation

  def call(channel_id:)
    channel = Yt::Channel.new(id: channel_id)
    Success(
      channel: channel,
      episodes: channel.videos.take(ENV.fetch('VIDEOS_TO_TAKE').to_i)
    )
  end
end