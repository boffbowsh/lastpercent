require 'rubygems'
require 'anemone/anemone'
dirname = File.dirname(__FILE__) + '/anemone/link'
Dir.open( dirname ).each do |fn|
  next unless ( fn =~ /[.]rb$/ )
  require "#{dirname}/#{fn}"
end
