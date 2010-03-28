eval IO.read("/Users/rubiii/deploy.domainfactory")

set :application, "rubiii"
set :rails_env, :production

set :deploy_to, "/kunden/#{df_account_number}_21033/apps/#{application}"
set :use_sudo, false

default_run_options[:pty] = true
set :scm, :git
set :deploy_via, :remote_cache
set :repository, "git@github.com:rubiii/rubiii.com.git"

role :app, "rubiii.com"
role :web, "rubiii.com"
role :db, "https://mysql5.rubiii.com", :primary => true

set :user, "ssh-#{df_account_number}-dh"
set :ssh_options, { :forward_agent => true }

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

before "deploy:restart" do
  database_configuration = render :template => <<-EOF
development:
  adapter: mysql
  encoding: utf8
  database: <%= df_db_database %>
  pool: 5
  username: <%= df_db_username %>
  password: <%= df_db_password %>
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
  timeout: 5000
EOF

  run "mkdir -p #{deploy_to}/#{shared_dir}/config" 
  put database_configuration, "#{deploy_to}/#{shared_dir}/config/database.yml" 
end

after "update_code" do
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml" 
end