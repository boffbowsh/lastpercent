require 'w3c_validators'

class LastPercentValidator::CSS < LastPercentValidator::Base
    
  def run
    @validator = W3CValidators::CSSValidator.new(:validator_uri => ValidatorConfig['css']['uri'])
    
    #results = @validator.validate_file(fp)
    results = @validator.validate_text(@asset.body)
    
    if results.errors.length > 0
      results.errors.each do |err|
        @results << { :severity => SEVERITY[:error], :line_no => err.line, :column_no => err.col, :body => err.message.strip[0..-3] }
      end
    end
    
    if results.warnings.length > 0
      results.warnings.each do |warn|
        @results << { :severity => SEVERITY[:warning], :line_no => warn.line, :column_no => warn.col, :body => warn.message.strip[0..-3] }
      end
    end
    
  end

end