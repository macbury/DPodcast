require 'dry/transaction/operation'

class UploadEpisode
  include Dry::Transaction::Operation

  def call(episode)
    episode_directory = Storage.episode_path(episode.channel_title, episode.id)
    cid_file_path = Storage.episode_cid_path(episode.channel_title, episode.id)

    unless File.exist?(cid_file_path)
      cid = Storage.store(episode_directory)
      File.write(cid_file_path, cid)
    end
    cid = File.read(cid_file_path)
    Success(cid)
  end
end