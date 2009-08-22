require 'rubygems'
require 'anemone/anemone'
require 'uri_extension'
dirname = File.dirname(__FILE__) + '/anemone/link'
Dir.open( dirname ).each do |fn|
  next unless ( fn =~ /[.]rb$/ )
  require "#{dirname}/#{fn}"
end
