#!/usr/bin/env ruby

ip = File.open(ARGV[0], 'r').readline.chomp.gsub(/[^0-9.]/,'')

if ip =~ /^137\.204\.13[245]\.\d+$/
  `gnome-terminal -e "ssh root@#{ip}" `
else
  File.open('/tmp/log', 'w+') { |f| f.puts ip }
end


