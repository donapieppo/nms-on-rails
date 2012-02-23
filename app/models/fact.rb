class Fact < ActiveRecord::Base
  belongs_to :ip

  def read_yaml
    self.ip
  end
end

