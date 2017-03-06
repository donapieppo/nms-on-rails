# record the first and last time for mac address on switch/port
class Port < ActiveRecord::Base
  belongs_to :switch

  def to_s
    "#{self.switch.name} #{self.port}"
  end
end
