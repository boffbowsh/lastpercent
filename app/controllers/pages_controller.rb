class PagesController < HighVoltage::PagesController
  skip_before_filter :ensure_valid, :except => :show
  
  def index
    @body_id = 'home'
    @site = Site.new
    @latest = Site.latest
  end
end