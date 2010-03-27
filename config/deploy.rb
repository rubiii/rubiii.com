domainfactory_account_number = IO.read("/Users/rubiii/domainfactory_account_number").chomp

set :application, "rubiii"
set :rails_env, :production

set :deploy_to, "/kunden/#{domainfactory_account_number}_21033/apps/#{application}"
set :use_sudo, false

default_run_options[:pty] = true
set :scm, :git
set :deploy_via, :remote_cache
set :repository, "git@github.com:rubiii/rubiii.com.git"

#role :app, "rubiii.com"
#role :web, "rubiii.com"
#role :db,  "rubiii.com", :primary => true
server "rubiii.com", :app, :web, :db, :primary => true

set :user, "ssh-#{domainfactory_account_number}-dh"
set :ssh_options, { :forward_agent => true }

namespace :deploy do
  task :restart, :roles => :app do             
    run "touch #{current_release}/tmp/restart.txt"
  end
end