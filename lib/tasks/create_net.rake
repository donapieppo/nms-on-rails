namespace :NmsOnRails do

  desc "Create a whole network" 
  task :create_network => :environment do 
    puts "Give me network name";                netname  = STDIN.gets.chomp
    puts "Give me network base (ex 192.168.1)"; netbase  = STDIN.gets.chomp
    puts "Give me first ip (ex 11)";            netstart = STDIN.gets.chomp
    puts "Give me last ip (ex 16)";             netend   = STDIN.gets.chomp

    net = Network.create!(:name => netname)

    (netstart..netend).each do |i|
      begin
        ip = net.ips.create!(:ip => "#{netbase}.#{i}")
      rescue 
        puts ip.errors.inspect
      end
      p ip
    end
  end

end

