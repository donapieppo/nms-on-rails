class Ip < ActiveRecord::Base
  has_many :arps
  has_many :infos

  has_one  :fact

  belongs_to :network
  belongs_to :arp,  :foreign_key => :last_arp_id
  belongs_to :info, :foreign_key => :last_info_id

  IP_REGEXP = /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/

  validates :ip, :format => { :with => IP_REGEXP, :message => "wrong ip format" }
  validates :conn_proto, :inclusion => { :in => %w(ssh rdp http), :message => "%{value} is not a valid protocol", :allow_nil => true }

  def last_arp
    self.arps.order('date desc').first
  end

  def last_info
    self.infos.order('date desc').first
  end

  def last_port
    Port.includes(:switch).where(:mac => self.last_arp.mac).order('last desc').first
  end

  def update_last_arp
    last = self.last_arp
    last and self.update_attribute(:last_arp_id, last.id)
  end

  def update_last_info
    last = self.last_info
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
    ip =~ IP_REGEXP or raise "wrong ip format #{ip.inspect}"
    ip
  end

end
