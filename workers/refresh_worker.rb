require 'sidekiq'
require "sinatra/activerecord"
require './models/source'

class RefreshWorker
  include Sidekiq::Worker

  def perform(id)
    ::Source.find(id).refresh_feed
  end
end
