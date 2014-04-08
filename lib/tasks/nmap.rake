namespace :NmsOnRails do
  namespace :nmap do
    NMAP_OS_DISCOVER='/usr/bin/sudo /usr/bin/nmap -F --max-os-tries 1 -n -O '

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

    def set_os(ip, os)
      puts "#{ip} #{os}"

      last_os = ip.last_os
      puts "last_os = #{last_os.inspect}"

      if last_os and last_os.name == os
        return
      else
        ip.oss.create!(name: os)
      end
    end

    desc "Os discover"
    task :os => :environment do
      Ip.includes(:os).where(:last_os_id => nil).each do |ip|
        res = `#{NMAP_OS_DISCOVER} #{ip.ip}`

        HOST_DOWN_MATCH.match(res) and next

        if unknown?(res)
          set_os(ip, '?')
        elsif linux?(res)
          set_os(ip, 'linux')
        elsif win7?(res)
          set_os(ip, 'Win7')
        elsif xp?(res)
          set_os(ip, 'Xp')
        else
          puts res
        end 
        sleep 2
      end
    end
  end
end
