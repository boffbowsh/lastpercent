class PagesController < HighVoltage::PagesController
  skip_before_filter :ensure_valid, :except => :show
end