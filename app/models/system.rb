class System < ActiveRecord::Base
  belongs_to :ip

  after_create :update_ip_last_system

  def update_ip_last_system
    self.ip.update_last_system
  end
end


