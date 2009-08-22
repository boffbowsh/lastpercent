require 'mechanize'
require 'raakt'

class LastPercentValidator::Accessibility < LastPercentValidator::Base
  def run
    raakttest = Raakt::Test.new(@asset.body)
    result = raakttest.all

    if result.length > 0
      result.each do |warn|
        @results << { :severity => SEVERITY[:warning], :line_no => nil, :column_no => nil, :body => warn.text }
      end
    end
  end
end