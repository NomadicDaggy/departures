class Airport < ActiveRecord::Base
	module Factories
		GEO = RGeo::Geographic.spherical_factory(:srid => 4326)
	end
	before_create :set_lonlat

	def longtitude
		long
	end
	def latitude
		lat
	end
	def lonlat
		Factories::GEO.point(longtitude, latitude)
	end

	private
	def set_lonlat
		self.lonlat = Factories::GEO.point(longtitude, latitude)
	end
end
