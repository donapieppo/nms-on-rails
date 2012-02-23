class Net < ActiveRecord::Base
  has_many :ips

  def to_s
    self.name
  end
end


