set :application, "set your application name here"
set :repository,  "set your repository location here"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "your app-server here"
role :web, "your web-server here"
role :db,  "your db-server here", :primary => true

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application} --set environment=#{rails_env}"
  end
end

after "deploy:symlink", "deploy:update_crontab"


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

after "deploy", "sphinx:rebuild"
