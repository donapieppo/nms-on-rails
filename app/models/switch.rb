class Switch < ActiveRecord::Base
  has_many :ports

  def to_s
    name
  end
end
