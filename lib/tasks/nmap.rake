namespace :NmsOnRails do
  namespace :nmap do
    NMAP_OS_DISCOVER = '/usr/bin/sudo /usr/bin/nmap -F --max-os-tries 1 -n -O '

    HOST_DOWN_MATCH = Regexp.new 'Host seems down', Regexp::MULTILINE
    UNKNOWN_MATCH   = [ Regexp.new('Too many fingerprints', Regexp::MULTILINE) ]

    def down?(res)
      HOST_DOWN_MATCH.match(res)
    end

    def unknown?(res)
      Regexp.new('Too many fingerprints', Regexp::MULTILINE).match(res) or
      Regexp.new('No exact OS matches for host', Regexp::MULTILINE).match(res)
    end

    def linux?(res)
      Regexp.new('22/tcp\s+open\s+ssh', Regexp::MULTILINE).match(res)
    end

    def win7?(res)
      Regexp.new('Running: Microsoft Windows 2008\|Vista\|7', Regexp::MULTILINE).match(res) or
      Regexp.new('Running: Microsoft Windows 7|Vista|2008', Regexp::MULTILINE).match(res)
    end

    def xp?(res)
      Regexp.new('Running: Microsoft Windows 2000\|XP', Regexp::MULTILINE).match(res) or 
      Regexp.new('Running: Microsoft Windows XP', Regexp::MULTILINE).match(res)
    end

    # Device type: print server
    # Device type: printer
    # Device type: printer|general purpose|webcam
    # 
    def printer?(res)
      Regexp.new('Device type:\s+.*print', Regexp::MULTILINE).match(res)
    end

    def macos?(res)
      Regexp.new('Running: Apple', Regexp::MULTILINE).match(res)
    end

    def set_system(ip, system)
      puts "#{ip} #{system}"

      last_system = ip.last_system
      puts "last_system = #{last_system.inspect}"

      if last_system and last_system.name == system
        return
      else
        ip.systems.create!(name: system, date: Time.now)
      end
    end

    desc "Os discover"
    task :system => :environment do
      Ip.includes(:system).where(:last_system_id => nil).each do |ip|
        res = `#{NMAP_OS_DISCOVER} #{ip.ip}`

        HOST_DOWN_MATCH.match(res) and next

        if unknown?(res)
          puts "NMAP has not found #{ip}. Checking from open ports."
        end
        if linux?(res)
          set_system(ip, 'linux')
        elsif win7?(res)
          set_system(ip, 'win7')
        elsif xp?(res)
          set_system(ip, 'xp')
        elsif macos?(res)
          set_system(ip, 'macos')
        elsif printer?(res)
          set_system(ip, 'printer')
        else
          puts "SYSTEM NOT FOUND WITH res"
          puts res
        end 
        sleep 2
      end
    end
  end
end
