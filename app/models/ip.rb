class Ip < ActiveRecord::Base
  has_many :arps
  has_many :infos

  has_one  :fact

  belongs_to :network
  belongs_to :arp,  :foreign_key => :last_arp_id
  belongs_to :info, :foreign_key => :last_info_id

  validates :conn_proto, :inclusion => { :in => %w(ssh rdp http), :message => "%{value} is not a valid protocol", :allow_nil => true }

  def update_last_arp
    last = self.arps.order('date desc').first
    last and self.update_attribute(:last_arp_id, last.id)
  end

  def update_last_info
    last = self.infos.order('date desc').first
    last and self.update_attribute(:last_info_id, last.id)
  end

  def last_arp
    self.arps.order('date desc').first
  end

  def last_seen
    self.arp or return 1000
    ((Time.zone.now.to_i - self.arp.date.to_i) / 86400).to_i + 1
  end

  def self.clean!(ip)
    ip =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/ or raise "wrong ip format #{ip.inspect}"
    ip
  end

end
