require 'dry/transaction/operation'
require 'builder'

class GeneratePodcast
  include Dry::Transaction::Operation

  def call(channel:, episodes: nil)
    channel_path = Storage.channel_path(channel.title)
    podcast_feed_path = channel_path.join('podcast.xml')

    xml = Builder::XmlMarkup.new(indent: 2)
    xml.instruct! :xml, version: '1.0'
    xml.rss version: '2.0', 'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd' do
      xml.channel do
        xml.title channel.title
        xml.link "https://www.youtube.com/channel/#{channel.id}"
        xml.description channel.description
        xml.itunes :image, href: podcast_url(channel, 'cover.jpg')

        episodes.each do |episode|
          xml.item do
            xml.title episode.title
            xml.description episode.description
            xml.pubDate episode.published_at.to_s(:rfc822)

            cid = open(Storage.episode_cid_path(channel.title, episode.id)).read
            xml.enclosure url: episode_url(cid, episode, 'episode.mp3'), type: 'audio/mp3'
            xml.itunes :image, href: episode_url(cid, episode, 'episode.jpg')
            xml.link "https://www.youtube.com/watch?v=#{episode.id}"
            xml.guid "https://www.youtube.com/watch?v=#{episode.id}"
          end
        end
      end
    end

    File.write(podcast_feed_path.to_s, xml.target!)
    Success(podcast_feed_path)
  end

  def podcast_url(channel, path)
    "#{ENV.fetch('IPFS_GATEWAY')}ipns/#{ENV.fetch('IPNS_KEY_HASH')}/channels/#{channel.title}/#{path}"
  end

  def episode_url(cid,episode,filename)
    "#{ENV.fetch('IPFS_GATEWAY')}ipfs/#{cid}/#{episode.id}/#{filename}"
  end
end