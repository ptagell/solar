require "open-uri"
require "csv"
require "date"
require "sinatra"
require "slim"


get '/' do

	dropbox_solar_url = "my-downloaded-page.csv"
	str16 = File.open(dropbox_solar_url, 'rb:UTF-16LE', headers:true) { |f| f.read }
	@solar_days = CSV.parse(str16.encode('UTF-8'), col_sep: "\t")


	dropbox_power_url = "62034707210_meter_usage_data_cipc1_11_2014.csv"
	raw_power_info = File.open(dropbox_power_url) { |f| f.read }
	@power_stats = CSV.parse(raw_power_info)


	# Series Data Arrays
	@period_date_values = []
	@period_grid_contribution_values = []
	@period_grid_consumption_values = []
	@period_solar_generation_values = []
	@period_solar_consumption_values = []

	# @period_date_values.push(d)

	def date_recorder(d)
		date = d.to_s
		@period_date_values.push(date)		
	end


	def daily_grid_consumption(d)
		daily_consumption_values = []
		@power_stats.each do |row|
			row_date = Date.parse(row[3])
			if row_date == d && row[2] == "Consumption"

				(5..53).each do |i|
					thirty_minute_usage = row[i].to_f
					daily_consumption_values.push(thirty_minute_usage)
				end
			end
		end
		@daily_grid_consumption = daily_consumption_values.inject(0, :+).round(2).to_s
		@period_grid_consumption_values.push(@daily_grid_consumption.to_i)
	end


	def daily_grid_contribution(d)
		daily_contribution_values = []
		@power_stats.each do |row|
			row_date = Date.parse(row[3])
			if row_date == d && row[2] == "Generation"
				(5..53).each do |i|
					thirty_minute_usage = row[i].to_f
					daily_contribution_values.push(thirty_minute_usage)
				end
			end
		end
		@daily_grid_contribution = daily_contribution_values.inject(0, :+).round(2).to_s
		@period_grid_contribution_values.push(@daily_grid_contribution.to_i)
	end


	def daily_solar_generation(d)
		@solar_days.each do |row|
			if row[0] == d.strftime('%Y-%m-%d')
				@daily_solar_generation = row[1]
				@period_solar_generation_values.push(@daily_solar_generation.to_i)
			end
		end
	end

	def daily_solar_consumption(a, b)

		@daily_solar_consumption = (a.to_f - b.to_f).round(2).to_s
		@period_solar_consumption_values.push(@daily_solar_consumption.to_i)
	end


	def grid_savings_from_solar(a, b)
		# total_cost_of_purchase

		# total_feed_in_tariff_rebate = @period_grid_contribution_values
	end
# @period_grid_contribution_values
# @period_solar_generation_values 
# @period_solar_consumtion_values 

	# def daily_calculations(n)
	
	# 	date = Date.today-n

	# 	daily_grid_consumption(date)
	# 	daily_solar_generation(date)
	# 	daily_grid_contribution(date)
	# 	daily_solar_consumption(@daily_solar_generation, @daily_grid_contribution)
	# 	# @daily_solar_consumption = @daily_solar_generation.to_f - @daily_grid_contribution.to_f
	# 	power_rate = "0.30"
	# 	feed_in_tariff = "0.067"

	# 	# puts "In total we used "+ (@daily_grid_consumption.to_f+@daily_solar_consumption.to_f).round(2).to_s+"kwh"
	# 	# puts "Solar used vs. power purchased "+ @daily_solar_consumption.round(2).to_s+ " / "+ @daily_grid_consumption.to_s
	# 	# puts "We saved $" + ((@daily_solar_consumption.to_f*power_rate.to_f).round(2)+(@daily_grid_contribution.to_f*feed_in_tariff.to_f)).round(2).to_s+" (Combination of power not purchased from grid and feed in tariff)"
	# 	# puts "We used "+ (@daily_solar_consumption/(@daily_solar_consumption.to_f+ @daily_grid_contribution.to_f)*100).round(2).to_s+"% of the solar we generated"
	# 	# puts "Should add up to " + @daily_solar_generation.to_s + " | " + (@daily_solar_consumption.to_f+ @daily_grid_contribution.to_f).round(2).to_s
	# 	#total power usage

	# end

	# @dsg = daily_solar_generation(n)
	# @dgc = daily_grid_contribution(Date.today-10)

	# @daily_contribution = daily_grid_contribution(Date.today-10)
	# @dc = daily_calculations(Date.today)

	slim :index

end
