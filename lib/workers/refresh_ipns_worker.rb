class RefreshIpnsWorker
  include Sidekiq::Worker

  def perform
    cid = Storage.store(Storage.channels_path)
    Storage.publish(cid)
  end
end