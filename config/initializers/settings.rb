begin
  Settings.url_limit = 70
  Settings.css_uri = 'http://127.0.0.1:8180/css-validator/validator'
  Settings.html_uri = 'http://127.0.0.1/cgi-bin/check'
  Settings.feed_uri = 'http://127.0.0.1/cgi-bin/check.cgi'
rescue
  RAILS_DEFAULT_LOGGER.error "You don't have a settings table yet, rake db:migrate!"
end