require 'dry/transaction/operation'
require 'open-uri'

class SaveChannelMetadata
  include Dry::Transaction::Operation

  def call(channel:, episodes:)
    channel_path = Storage.channel_path(channel.title)
    FileUtils.mkdir_p(channel_path.to_s)

    cover_path = channel_path.join('cover.jpg')
    
    File.open(cover_path, 'wb') do |saved_file|
      open(channel.thumbnail_url('high'), 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end

    Success(cover_path)
  end
end