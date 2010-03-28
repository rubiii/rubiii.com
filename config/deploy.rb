eval IO.read("/Users/rubiii/deploy.domainfactory")

set :application, "rubiii"
set :rails_env, :production

set :deploy_to, "#{df_account_folder}/apps/#{application}"
set :use_sudo, false

default_run_options[:pty] = true
set :scm, :git
set :deploy_via, :remote_cache
set :repository, "git@github.com:rubiii/rubiii.com.git"

role :app, "rubiii.com"
role :web, "rubiii.com"
role :db, "rubiii.com", :primary => true

set :user, df_ssh_username
set :ssh_options, { :forward_agent => true }

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

after "deploy:update_code" do
  database_configuration = "
development:
  adapter: mysql
  encoding: utf8
  database: #{df_db_database}
  pool: 5
  username: #{df_db_username}
  password: #{df_db_password}
  host: #{df_db_host}
  socket: /var/run/mysqld/mysqld.sock

test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

production:
  adapter: sqlite3
  database: db/production.sqlite3
  pool: 5
  timeout: 5000"

  run "mkdir -p #{deploy_to}/#{shared_dir}/config" 
  put database_configuration, "#{deploy_to}/#{shared_dir}/config/database.yml" 
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml" 
end