class System < ApplicationRecord
  belongs_to :ip

  after_save :update_ip_last_system

  def update_ip_last_system
    self.ip.update_last_system
  end
end


