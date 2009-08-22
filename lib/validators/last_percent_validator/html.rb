require 'w3c_validators'
include W3CValidators

class LastPercentValidator::HTML < LastPercentValidator::Base
    
  def run
    validator = MarkupValidator.new
    puts "working on: #{@asset.url}"
    #results = @validator.validate_file(fp)
    results = validator.validate_uri(@asset.url)

    if results.errors.length > 0
      results.errors.each do |err|
        @results << { :severity => SEVERITY[:error], :line_no => err.line, :column_no => err.col, :body => err.message }
      end
    end

    if results.warnings.length > 0
      results.warnings.each do |warn|
        @results << { :severity => SEVERITY[:warning], :line_no => warn.line, :column_no => warn.col, :body => warn.message }
      end
    end
  end

end