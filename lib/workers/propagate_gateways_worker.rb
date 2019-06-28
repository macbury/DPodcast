require 'open-uri'

class PropagateGatewaysWorker
  include Sidekiq::Worker
  GATEWAYS_LIST_URL = 'https://raw.githubusercontent.com/ipfs/public-gateway-checker/master/gateways.json'

  def perform
    JSON.parse(open(GATEWAYS_LIST_URL).read).each do |gateway|
      ipns_url = gateway.gsub('ipfs/:hash', 'ipns/'+ENV.fetch('IPNS_KEY_HASH'))
      PingGatewayWorker.perform_async(ipns_url)
    end
  end
end