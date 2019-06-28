require "dry/container"
require "dry/transaction"
require "dry/transaction/operation"
require_relative './operations/download_video'
require_relative './operations/fetch_video'
require_relative './operations/save_channel_metadata'
require_relative './operations/resolve_channel'
require_relative './operations/cleanup'
require_relative './operations/upload_episode'
require_relative './operations/generate_podcast'

class Transactions
  extend Dry::Container::Mixin

  namespace 'yt' do
    register 'fetch_video' do
      FetchVideo.new
    end
    register 'resolve_channel' do
      ResolveChannel.new
    end
    register 'download_video' do
      DownloadVideo.new
    end
    register 'save_channel_metadata' do
      SaveChannelMetadata.new
    end
  end

  namespace 'podcast' do
    register 'cleanup' do
      Cleanup.new
    end
    register 'generate' do
      GeneratePodcast.new
    end
  end

  namespace 'ipfs' do
    register 'upload_episode' do
      UploadEpisode.new
    end
  end
end

Transaction = Dry::Transaction(container: Transactions)