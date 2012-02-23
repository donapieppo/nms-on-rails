class Info < ActiveRecord::Base
  belongs_to :user
  belongs_to :ip

  # validates :name, :format => { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" }
  after_create :update_ip_last_info

  def update_ip_last_info
    self.ip.update_last_info
  end
end
