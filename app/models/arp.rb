class Arp < ActiveRecord::Base
  belongs_to    :ip

  def to_s
    "#{self.ip.ip} #{self.date}"
  end
end
