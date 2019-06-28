require 'dry/transaction/operation'
require 'yt'

class Cleanup
  include Dry::Transaction::Operation

  def call(channel:, episodes: nil)
    ep_dir = Dir.glob(Storage.channel_path(channel.title).join('*')).reject { |p| File.file?(p) }.sort do |a, b|
      File.mtime(b) <=> File.mtime(b)
    end
    
    ep_dir[offset..-1]&.each do |dir_to_remove|
      FileUtils.rm_r(dir_to_remove)
      # TODO extract episode id and remove cid if exists
    end
  end

  def offset
    ENV.fetch('VIDEOS_TO_TAKE').to_i + 1
  end
end