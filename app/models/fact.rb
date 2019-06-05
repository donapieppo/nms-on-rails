class Fact < ApplicationRecord
  belongs_to :ip

  def read_yaml
    self.ip
  end
end

