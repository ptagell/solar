require "open-uri"
require "csv"

# require 'charlock_holmes'


remote_base_url = "1223432495_log_daily.csv"

remote_data = open(remote_base_url).read
daily_generation_log = open("my_downloaded_daily_generation_log.csv", "w") 

daily_generation_log.write(remote_data)
daily_generation_log.close


# Check character encoding to stop from breaking


# contents = File.read('my_downloaded_daily_generation_log.csv')
# detection = CharlockHolmes::EncodingDetector.detect(contents)
# # => {:encoding => 'UTF-8', :confidence => 100, :type => :text}


# utf8_encoded_content = CharlockHolmes::Converter.convert contents, detection[:encoding], 'UTF-8'


# CSV.read("62034707210_meter_usage_data_cipc1_11_2014.csv")

CSV.read("my_downloaded_daily_generation_log.csv", :col_sep => "\t")

puts "Done"