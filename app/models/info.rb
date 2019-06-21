class Info < ApplicationRecord
  belongs_to :ip
  belongs_to :user, optional: true

  # validates :name, :format => { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" }
  before_save  :set_date
  after_create :update_ip_last_info

  scope :actual_printers, -> { group(:ip_id).order('date desc').where(system: "printer") }

  def set_date
    self.date = Time.now
  end

  def update_ip_last_info
    self.ip.update_last_info
  end

  def to_s
    (self.name || "_undefined_") + " (#{self.dnsname})"
  end

end
