require 'open-uri'
require 'timeout'
class PingGatewayWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform(ipns_url)
    Timeout.timeout(5) do
      open(ipns_url).read
    end
  rescue Errno::ECONNRESET, Timeout::Error, OpenURI::HTTPError, SocketError, OpenSSL::SSL::SSLError
  end
end