
require "sinatra"

require "open-uri"
require "csv"
require "date"

require "slim"




get '/' do
	@data = "Hello there doufus"
	# say_hello
 	# @data = daily_solar_generation(Date.today)
 	slim :index

end

