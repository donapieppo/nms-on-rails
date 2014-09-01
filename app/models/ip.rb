class Ip < ActiveRecord::Base
  has_many :infos
  has_many :arps
  has_many :systems

  has_one  :fact

  belongs_to :network
  belongs_to :arp,    :foreign_key => :last_arp_id
  belongs_to :info,   :foreign_key => :last_info_id
  belongs_to :system, :foreign_key => :last_system_id

  validates :ip, :format => { :with => NmsOnRails::REGEXP_FOR_IP, :message => "wrong ip format" }
  validates :conn_proto, :inclusion => { :in => %w(ssh rdp http), :message => "%{value} is not a valid protocol", :allow_nil => true }

  def last_arp
    self.arps.order('date desc').first
  end

  def last_info
    self.infos.order('date desc').first
  end

  def last_system
    self.systems.order('date desc').first
  end

  def last_port
    last = self.last_arp
    last ? Port.includes(:switch).where(:mac => last).order('last desc').first : nil
  end

  def update_last_arp
    last = self.last_arp
    last and self.update_attribute(:last_arp_id, last.id)
  end

  def update_last_info
    last = self.last_info
    last and self.update_attribute(:last_info_id, last.id)
  end

  def update_last_system
    last = self.last_system
    last and self.update_attribute(:last_system_id, last.id)
  end

  def last_seen
    self.arp or return 1000
    ((Time.zone.now.to_i - self.arp.date.to_i) / 86400).to_i + 1
  end

  def self.clean!(ip)
    NmsOnRails::REGEXP_FOR_IP.match(ip) or raise "wrong ip format #{ip.inspect}"
    ip
  end

  def clean_ip
    NmsOnRails::REGEXP_FOR_IP.match(self.ip) or raise "wrong ip format #{self.ip.inspect}"
    self.ip
  end


  def to_s
    self.ip
  end
end
