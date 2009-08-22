set :branch,          'staging'
set :rails_env,       'staging'

set :domain,          'staging.lastpercent.com'
set :domain_aliases,  'www.staging.lastpercent.com'

set :local_shared_files, %w(config/database.yml db/sphinx config/staging.sphinx.conf)

## List of servers
server "lastpercent.com", :app, :web, :db, :primary => true

# Target directory for the application on the web and app servers.
set(:deploy_to) { File.join("", "home", "rails", application, stage.to_s) }