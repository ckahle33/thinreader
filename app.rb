require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/activerecord"
require "better_errors"
require 'dotenv/load'
require "pry"

require "./models/source"
require "./models/article"

require './api/news'
require './api/text'

set :root, File.dirname(__FILE__)

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

set :views, "views"

get '/' do
  @sources = Source.all

  haml :index, layout: :main
end

get '/:source' do
  @sources = Source.all
  @title = Source.where(slug: params['source']).first.name
  @articles = Article.where(source_name: params['source'])

  haml :source, layout: :main
end

get '/:source/:article' do
  @sources = Source.all
  @article = Article.where(slug: params['article']).first

  haml :article, layout: :main
end

helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
end
