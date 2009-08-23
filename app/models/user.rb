class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.openid_required_fields = [:email, :nickname]
    c.maintain_sessions = false
    def attributes_to_save # :doc:
      attrs_to_save = attributes.clone.delete_if do |k, v|
        [ :persistence_token, :perishable_token, :single_access_token, :login_count,
          :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip, :created_at,
          :updated_at, :lock_version].include?(k.to_sym)
      end
    end
  end

  is_gravtastic :with => :email, :rating => 'R', :size => 40

  is_paranoid

  has_many :sites, :dependent => :destroy

  def map_openid_registration(registration)
    self.email = registration["email"] if email.blank?
    self.first_name = registration["nickname"] if first_name.blank?
  end

  def to_s
    first_name.present? ? first_name : email
  end

  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def activate!
    self.update_attributes(:activated_at => Time.now)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end
end