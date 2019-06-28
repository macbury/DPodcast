require 'terrapin'

class Storage
  def self.path
    @path ||= Pathname.new(File.expand_path('./data/'))
  end

  def self.channels_path
    path.join('channels')
  end

  def self.episodes_path
    path.join('episodes')
  end

  def self.channel_path(channel_title)
    channels_path.join(channel_title)
  end

  def self.episode_path(channel_title, episode_id)
    episodes_path.join(channel_title).join(episode_id)
  end

  def self.episode_cid_path(channel_title, episode_id)
    episode_directory = episode_path(channel_title, episode_id)
    return "#{episode_directory.to_s}.cid"
  end

  def self.api
    ENV.fetch('IPFS_API_ENDPOINT')
  end

  def self.store(file_path)
    Terrapin::CommandLine.new('ipfs', 'add --api :api -Q -r -w :file_path').run(file_path: file_path, api: api).strip
  end

  def self.publish(cid)
    Terrapin::CommandLine.new('ipfs', 'name publish --api :api -t 2.5h -Q --key=:key /ipfs/:cid').run(cid: cid, api: api, key: ENV.fetch('IPNS_KEY_NAME')).strip
  end

  def self.pin(cid)
    Terrapin::CommandLine.new('ipfs', 'pin add --api :api -r :cid').run(cid: cid, api: api).success?
  end

  def self.rm(cid)
    Terrapin::CommandLine.new('ipfs', 'files rm --api :api -r :cid').run(cid: cid, api: api).success?
  end
end