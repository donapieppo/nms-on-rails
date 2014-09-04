#!/usr/bin/env ruby

ip = File.open(ARGV[0], 'r').readline.chomp.gsub(/[^0-9.]/,'')

if ip =~ /^\d+\.\d+\.\d+\.\d+$/
  `gnome-terminal -e "ssh root@#{ip}" `
else
  File.open('/tmp/log', 'w+') { |f| f.puts ip }
end


