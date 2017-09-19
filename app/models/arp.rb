# record the last seen association of mac address and ip
class Arp < ApplicationRecord
  belongs_to    :ip

  def to_s
    "#{self.ip.ip} #{self.date}"
  end
end
