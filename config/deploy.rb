lock '3.4.1'

set :application, 'property'
set :repo_url, 'git@github.com:omairrazam/property.git' # Edit this to match your repository
set :branch, :master
set :deploy_to, '/home/deploy/property'
set :pty, false
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, '2.4.2'

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end

task :update_git_repo do
	on release_roles :all do
	  with fetch(:git_environmental_variables) do
	    within repo_path do
	      current_repo_url = execute :git, :config, :'--get', :'remote.origin.url'
	      unless repo_url == current_repo_url
	        execute :git, :remote, :'set-url', 'origin', repo_url
	        execute :git, :remote, :update

	        execute :git, :config, :'--get', :'remote.origin.url'
	      end
	    end
	  end
	end
end

namespace :sidekiq do

  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end

  before 'deploy:finished', 'sidekiq:restart'

  task :stop do
    on roles(:app) do
      within current_path do
        pid = p capture "ps aux | grep sidekiq | awk '{print $2}' | sed -n 1p"
        execute("kill -9 #{pid}")
      end
    end
  end

  task :start do
    on roles(:app) do
      within current_path do
        execute :bundle, "exec sidekiq -e #{fetch(:stage)} -C config/sidekiq.yml -d"
      end
    end
  end
end