require 'dry/transaction/operation'
require 'yt'

# sometimes channel is obscured by username, and there is no api query for fetching user data in yt api :(
class ResolveChannel
  include Dry::Transaction::Operation

  def call(channel_id: nil, video_id: nil)
    if video_id 
      video = Yt::Video.new(id: video_id)
      channel_id = video.channel_id
    end
    
    Success(channel_id: channel_id)
  end
end