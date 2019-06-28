require 'dry/transaction/operation'
require 'terrapin'
require 'yaml'

class DownloadVideo
  include Dry::Transaction::Operation

  def call(channel_id:, episode:)
    within_storage(episode.channel_title, episode) do |storage_path|
      final_mp3_file = File.join(storage_path, 'episode.mp3')
      return Success(final_mp3_file) if File.exists?(final_mp3_file)

      begin
        yt_dl.run(
          id: episode.id,
          output_template: storage_path.join('episode.%(ext)s').to_s
        )
        return Success(final_mp3_file)
      rescue => e
        Failure(e)
      end
    end
  end

  private

  def yt_dl
    @yt_dl ||= Terrapin::CommandLine.new("youtube-dl", "--no-check-certificate -o :output_template --extract-audio --audio-format mp3 --audio-quality 2 --embed-thumbnail --add-metadata --write-thumbnail :id")
  end

  def within_storage(channel_title, episode, &block)
    path = Storage.episode_path(channel_title, episode.id)
    FileUtils.mkdir_p(path)
    block.call(path)
  end
end