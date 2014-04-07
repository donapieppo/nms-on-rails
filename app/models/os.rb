class Os < ActiveRecord::Base
  belongs_to :ip

  after_create :update_ip_last_os

  def update_ip_last_os
    self.ip.update_last_os
  end
end


