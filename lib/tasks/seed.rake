require 'csv'
require 'db_sanitize'
include DBSanitize

CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

namespace :db do
  namespace :seed do
    desc "Import airport data"
    task :import_airports => :environment do
      if Airport.count == 0
        filename     = Rails.root.join('db', 'data_files', 'airports.csv')
        fixed_quotes = File.read(filename).gsub(/\\"/,'""')
        CSV.parse(fixed_quotes, :headers => true, :header_converters => :symbol, :converters => [:blank_to_nil]) do |row|
          Airport.create(row.to_hash)
        end
      end
    end

    desc "Import airline/carrier data"
		task :import_carriers => :environment do
		  if Carrier.count == 0
		    filename = Rails.root.join('db', 'data_files', 'carriers.csv')
		    CSV.foreach(filename, :headers => true, :header_converters => :symbol) do |row|
		      Carrier.create(row.to_hash)
		    end
		  end
		end

		CSV::Converters[:na_to_nil] = lambda do |field|
		  field && field == "NA" ? nil : field
		end
		
		desc "Import flight departures data"
		task :import_departures => :environment do
		  if Departure.count == 0
		    filename  = Rails.root.join('db', 'data_files', '1999.csv')
		    timestamp = Time.now.to_s(:db)
		    CSV.foreach(
		      filename,
		      :headers           => true,
		      :header_converters => :symbol,
		      :converters        => [:na_to_nil]
		    ) do |row|
		      puts "#{$.} #{Time.now}" if $. % 10000 == 0
		      data = {
		        :year                => integer(row[:year]),
		        :month               => integer(row[:month]),
		        :day_of_month        => integer(row[:dayofmonth]),
		        :day_of_week         => integer(row[:dayofweek]),
		        :dep_time            => integer(row[:deptime]),
		        :crs_dep_time        => integer(row[:crsdeptime]),
		        :arr_time            => integer(row[:arrtime]),
		        :crs_arr_time        => integer(row[:crsarrtime]),
		        :unique_carrier      => string(row[:uniquecarrier]),
		        :flight_num          => integer(row[:flightnum]),
		        :tail_num            => string(row[:tailnum]),
		        :actual_elapsed_time => integer(row[:actualelapsedtime]),
		        :crs_elapsed_time    => integer(row[:crselapsedtime]),
		        :air_time            => integer(row[:airtime]),
		        :arr_delay           => integer(row[:arrdelay]),
		        :dep_delay           => integer(row[:depdelay]),
		        :origin              => string(row[:origin]),
		        :dest                => string(row[:dest]),
		        :distance            => integer(row[:distance]),
		        :taxi_in             => integer(row[:taxiin]),
		        :taxi_out            => integer(row[:taxiout]),
		        :cancelled           => boolean(row[:cancelled]),
		        :cancellation_code   => string(row[:cancellationcode]),
		        :diverted            => boolean(row[:diverted]),
		        :carrier_delay       => integer(row[:carrierdelay]),
		        :weather_delay       => integer(row[:weatherdelay]),
		        :nas_delay           => integer(row[:nasdelay]),
		        :security_delay      => integer(row[:securitydelay]),
		        :late_aircraft_delay => integer(row[:lateaircraftdelay]),
		        :created_at          => string(timestamp),
		        :updated_at          => string(timestamp)
		      }
		      sql = "INSERT INTO departures (#{data.keys.join(',')})"
		      sql += " VALUES (#{data.values.join(',')})"
		      ActiveRecord::Base.connection.execute(sql)
		    end
		  end
		end

  end
end