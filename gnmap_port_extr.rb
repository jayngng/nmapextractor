#!/usr/bin/ruby


begin

  # Read IP address.
  ip = ARGV[0].gsub(".","\\.")

  # Read options
  options = ["-open", "-close", "-filtered"]

  # Read port state
  state = ARGV[1][1..-1] if options.include? ARGV[1]

  # Set default state
  state = "open" if !state

  # Read file input
  file = ARGV[2] if ARGV[2]
  file = ARGV[1] if !file

  # Read pattern
  glob_pattern = /^Host:\s+#{ip}\s+\(\)\s+Port(?:.)*\n/
  
  # Read file
  stream = File.new(file, "r")
  stream.each do |line|
    line.match(glob_pattern) do

      # Read port
      port = /(?:(\d+\/#{state}\/\w+\/\/.+?)\/)/

      # Extract pattern
      ports =  line.scan(port)

      # Reformat output
      ports.each { |p| puts p.join("\n").gsub("\/", "\t")}
    end
  end
rescue Exception => e
  puts e
end


