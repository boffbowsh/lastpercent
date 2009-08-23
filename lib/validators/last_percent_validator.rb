module LastPercentValidator
  class Base
    attr_accessor :check, :validator
    attr_reader :results

    SEVERITY = { :info => 0, :warning => 1, :error => 2 }

    def initialize(check)
      @results = []

      unless check.is_a?(Check)
        check = ::Check.find(check, :include => [:validator, :asset])
      end

      @check = check
      @validator = @check.validator
      @asset = @check.asset

    rescue
      raise "FATAL ERROR FATAL: Check/Validator data did not load correctly"
    end

    def run
      raise "YOU NEED TO OVERRIDE ME"
    end

    def save
      @results.each do |result|
        res = ::Result.new
        res.check_id = @check.id
        res.asset_id = @asset.id
        res.message = ::Message.find_or_create_by_body_and_validator_id(result[:body], @validator.id)
        res.severity = result[:severity]
        res.line_no = result[:line_no]
        res.column_no = result[:column_no]
        res.save!
      end
    end
  end
end