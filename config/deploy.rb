gem 'brightbox', '>=2.3.5'
require 'brightbox/recipes'
require 'brightbox/passenger'

# Multistage deployment
set :stages, %w(staging production dwayne)
set :default_stage, "dwayne"
require 'capistrano/ext/multistage'

set :application, "lastpercent"
set :user, "rails"

set :keep_releases, 5
set :scm_verbose, true
set :deploy_via, :remote_cache
set :repository, "git@github.com:railsrumble/rr09-team-70.git"
set :scm, :git

on :start do
  `ssh-add`
end

depend :remote, :gem, 'capistrano-ext',                   ">0"
depend :remote, :gem, 'chronic',                          ">0"
depend :remote, :gem, 'javan-whenever',                   ">0", :source => 'http://gems.github.com'
depend :remote, :gem, 'freelancing-god-thinking-sphinx',  ">0", :source => 'http://gems.github.com'
depend :remote, :gem, 'jchupp-is_paranoid',               ">0", :source => 'http://gems.github.com'
depend :remote, :gem, 'thoughtbot-paperclip',             ">0", :source => 'http://gems.github.com'
depend :remote, :gem, 'newrelic_rpm',                     ">0"
depend :remote, :gem, 'authlogic',                        ">0"
depend :remote, :gem, 'haml',                             ">0"
depend :remote, :gem, 'mislav-will_paginate',             ">0"

set :local_shared_files, %w(config/database.yml db/sphinx)

ssh_options[:forward_agent] = true
default_run_options[:pty] = true


namespace :db do
  desc 'Dumps the production database to db/production_data.sql on the remote server'
  task :remote_db_dump, :roles => :db, :only => { :primary => true } do
    run "cd #{deploy_to}/#{current_dir} && " +
      "rake RAILS_ENV=#{rails_env} db:database_dump --trace"
  end
 
  desc 'Downloads db/production_data.sql from the remote production environment to your local machine'
  task :remote_db_download, :roles => :db, :only => { :primary => true } do
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.download!("#{deploy_to}/#{current_dir}/db/#{rails_env}_data.sql", "db/#{rails_env}_data.sql")
      end
    end
  end
 
  desc 'Cleans up data dump file'
  task :remote_db_cleanup, :roles => :db, :only => { :primary => true } do
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.remove! "#{deploy_to}/#{current_dir}/db/#{rails_env}_data.sql"
      end
    end
  end
 
  desc 'Dumps, downloads and then cleans up the production data dump'
  task :remote_db_runner do
    remote_db_dump
    remote_db_download
    remote_db_cleanup
  end
  
  desc 'Migrates down to zero, and then backup to latest'
  task :remigrate do
    run "cd #{deploy_to}/#{current_dir} &&" +
      "rake RAILS_ENV=#{rails_env} db:migrate VERSION=0 &&" +
      "rake RAILS_ENV=#{rails_env} db:migrate"
  end
end

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application} --set environment=#{rails_env}"
  end
end

namespace :sphinx do
  desc "Generate the sphinx index"
  task :index, :roles => :app do
    run "cd #{current_path} && rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end

  desc "Configure sphinx"
  task :configure, :roles => :app do
     run "cd #{current_path} && rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end

  desc "Stop the sphinx server"
  task :stop, :roles => :app do
    run "cd #{current_path} && rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end

  desc "Start the sphinx server"
  task :start, :roles => :app do
    run "cd #{current_path} && rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end

  desc "Restart the sphinx server"
  task :rebuild, :roles => :app do
    run "cd #{current_path} && rake thinking_sphinx:rebuild RAILS_ENV=#{rails_env}"
  end
end

after "deploy:symlink", "deploy:update_crontab"
after "deploy", "sphinx:rebuild"