eval IO.read("/Users/rubiii/deploy.domainfactory")

set :application, "rubiii"
set :rails_env, :production

# domainfactory
set :deploy_to, "#{df_account_folder}/apps/#{application}"
set :use_sudo, false

# github
set :scm, :git
set :deploy_via, :remote_cache
set :repository, "git@github.com:rubiii/rubiii.com.git"
default_run_options[:pty] = true

# roles
server "rubiii.com", :app, :web, :db, :primary => true

# ssh
set :user, df_ssh_username
set :ssh_options, { :forward_agent => true }

# passenger
namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

# upload and symlink database.yml from shared folder
after "deploy:update_code" do
  database_yml = IO.read("/Users/rubiii/database.domainfactory")

  run "mkdir -p #{deploy_to}/#{shared_dir}/config"
  put database_yml, "#{deploy_to}/#{shared_dir}/config/database.yml"
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
end

# symlink public/docs from shared folder
after "deploy:update_code" do
  run "ln -nfs #{deploy_to}/#{shared_dir}/docs #{release_path}/public/docs" 
end

# cleanup after deployment
after "deploy", "deploy:cleanup"