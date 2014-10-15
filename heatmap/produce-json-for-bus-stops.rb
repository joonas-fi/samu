require 'json'
require './common.rb'

datasource = ARGV[0]

unless datasource
	puts "First argument must be path to datasource file"
	exit!
end

# Data examples
#
# routes.txt:
# 	stop_id,stop_code,stop_name,stop_lat,stop_lon
#   0001,0001,Keskustori M,61.49751,23.76151
#   0002,0002,Keskustori L,61.49756,23.76148
#

def bus_stop_coordinates_from_original_data(bus_stops)

	ret = []
	bus_stops.each do |stop|
		
		processed = []
		processed.push stop["stop_lat"].to_f
		processed.push stop["stop_lon"].to_f
		
		ret.push processed
	end
	
	ret
end


stops_original = parse_gtfs_file(datasource)

puts "Read #{stops_original.length} bus-stops"

stops = bus_stop_coordinates_from_original_data(stops_original)

filename = "stops.js"

File.open(filename, "w") do |file|
	# the file is not strictly JSON (hence extension .js)
	file.write "var busStops = "

	# the rest are JSON
	file.write(stops.to_json)
end

puts "#{stops.length} bus-stop(s) written to #{filename}"
