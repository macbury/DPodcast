class DistributePodcast
  include Transaction

  step :resolve_channel, with: 'yt.resolve_channel'
  step :fetch_video, with: 'yt.fetch_video'
  tee :download_videos
  tee :save_metadata, with: 'yt.save_channel_metadata'
  tee :cleanup, with: 'podcast.cleanup'
  tee :upload_episodes
  tee :generate_podcast, with: 'podcast.generate'

  def download_videos(episodes:, channel:)
    episodes.each do |episode|
      download_video.call(channel_id: channel.id, episode: episode)
    end
  end

  def upload_episodes(episodes:, channel:)
    episodes.each do |episode|
      cid = upload_episode.call(episode).success
    end
  end

  private

  def download_video
    @download_video ||= DownloadVideo.new
  end

  def upload_episode
    @upload_episode ||= UploadEpisode.new
  end
end