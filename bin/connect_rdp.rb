#!/usr/bin/ruby

ip = File.open(ARGV[0], 'r').readline.chomp.gsub(/[^0-9.]/,'')

if ip =~ /^137\.204\.13[245]\.\d+$/
  #`gnome-terminal -e "rdesktop -U administrator #{ip}" `
  `rdesktop -g 1024x768 -u administrator "#{ip}"`
  File.open('log', 'w+') do |f| 
    f.puts ARGV[0]
    f.puts ip 
  end
end


