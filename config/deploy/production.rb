set :branch,          'production'
set :rails_env,       'production'

set :domain,          'lastpercent.com'
set :domain_aliases,  'www.lastpercent.com, production.lastpercent.com'

set :local_shared_files, %w(config/database.yml db/sphinx config/production.sphinx.conf)

## List of servers
server "lastpercent.com", :app, :web, :db, :primary => true

# Target directory for the application on the web and app servers.
set(:deploy_to) { File.join("", "home", "rails", application, stage.to_s) }