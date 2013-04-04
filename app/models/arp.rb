class Arp < ActiveRecord::Base
  belongs_to    :ip

  attr_accessible :mac, :date

  def to_s
    "#{self.ip.ip} #{self.date}"
  end
end
