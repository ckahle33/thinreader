# config valid for current version and patch releases of Capistrano
lock "~> 3.11.1"

set :application, "flatreader"
set :repo_url, "git@github.com:ckahle33/flatreader.git"
set :user, "flatreader"

set :deploy_to, "/home/flatreader"
set :tmp_dir, "/home/flatreader/tmp"

set :npm_flags, '--production'

set :chruby_ruby, 'ruby-2.5.0'
set :passenger_restart_with_touch, true

set :linked_files, %w{ .env }
set :linked_dirs, %w{ log }

set :ssh_options, {
  forward_agent: "true",
  auth_methods: ["publickey"],
  keys: ["/Users/cpk/.ssh/flatreader"]
}

after "deploy", "deploy:webpack_build"

namespace :deploy do
  task :webpack_build do
    on roles(:app) do
      within current_path do
        execute "webpack --config webpack.config.js"
      end
    end
  end
end
