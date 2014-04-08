# record the last seen association of mac address and ip
class Arp < ActiveRecord::Base
  belongs_to    :ip

  def to_s
    "#{self.ip.ip} #{self.date}"
  end
end
