class LastPercentValidator::Lorem < LastPercentValidator::Base
  def run
    if @asset.body =~ /lorem ipsum/i
      @results << { :severity => SEVERITY[:warning], :line_no => nil, :column_no => nil, :body => "Lorem ipsum has been detected" }
    end
  end
end