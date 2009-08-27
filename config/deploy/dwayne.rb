set :branch,          'staging'
set :rails_env,       'staging'

set :domain,          'lastpercent.staging.rawnet.local'
set :domain_aliases,  'www.lastpercent.staging.rawnet.local'

set :local_shared_files, %w(config/database.yml db/sphinx config/staging.sphinx.conf)

## List of servers
server "dwayne.rawnet.local", :app, :web, :db, :primary => true

# Target directory for the application on the web and app servers.
set(:deploy_to) { File.join("", "home", "rails", application, rails_env.to_s) }