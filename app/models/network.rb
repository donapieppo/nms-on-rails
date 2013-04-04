class Network < ActiveRecord::Base
  has_many :ips

  attr_accessible :name, :description

  def to_s
    self.name
  end
end


