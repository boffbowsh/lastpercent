require 'w3c_validators'

class LastPercentValidator::HTML < LastPercentValidator::Base
    
  def run
    validator = W3CValidators::MarkupValidator.new(:validator_uri => 'http://dwayne.rawnet.local/w3c-markup-validator/check')
    #results = @validator.validate_file(fp)
    results = validator.validate_uri(@asset.url)
    
    results.errors.each do |err|
      @results << { :severity => SEVERITY[:error], :line_no => err.line, :column_no => err.col, :body => err.message }
    end

    results.warnings.each do |warn|
      @results << { :severity => SEVERITY[:warning], :line_no => warn.line, :column_no => warn.col, :body => warn.message }
    end
  end

end