#!/usr/bin/ruby

begin

  # Read ip input from user
  ip = ARGV[0].gsub(".", "\\.")

  # options
  options = ["-open", "-close", "-filtered"]

  # check port state
  # truncate the minus from user input
  state = ARGV[1][1..-1] if options.include? ARGV[1]
  # set default port state
  state = "open" if !state

  # if the argument is file
  file = ARGV[2] if ARGV[2]
  file = ARGV[1] if !file
  
  # ip and port state 
  ip_pattern = /^Nmap scan report for #{ip}$/ 
  up_host_pattern = /^Host is up (?:.)*\n/
  port_pattern = /^(\d+\/\w+\s+#{state}\s+.+\n)/


  # Read file and find matching pattern
  stream = File.new(file, "r")
  stream.each do |line|
    line.match(ip_pattern) do

      # Check if host is up
      stream.readline.match(up_host_pattern) do

        # if match →  extract port
        stream.readline # → Read "Not shown..."
        stream.readline # → Read "PORT STATE SERVICE VERSION"

        stream.each do |line|
          line =~ port_pattern
          puts $1 if $1
          break if line == "\n"
        end
      end
    end
  end
rescue Exception => e
  puts e
end
