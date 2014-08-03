require "rest_client"
require "json"
YO_URL = "http://api.justyo.co/yo/"

module Cli_Yo
	@short_cut_mapping = {
		s: :silent,
		a: :api_token,
		c: :count , 
		i: :interval
	}
	@all_properties = [:silent , :count , :username , :api_token , :interval];
	@numeric_properties = [:count , :interval];
	@mandatory_properties = [:username , :api_token]

	class << self
		attr_reader :short_cut_mapping , :all_properties , :numeric_properties , :mandatory_properties
	end

	class Yo_Error < Exception
		def initialize error , code = nil
			@error = error
			@code = code
		end

		def to_s
			if @code
				"Error code #{@code} => #{@error}"
			else
				@error
			end
		end
	end

	class Yo_Arguments
		def initialize arguments = Hash.new
			@arguments = Hash.new
			Cli_Yo.all_properties.each do |prop|
				@arguments[prop] = arguments[prop]
			end
			@arguments[:count] ||= 1
			@arguments[:api_token] ||= `echo $YO_TOKEN`.chomp
			@arguments[:interval] ||= 1
		end

		def method_missing method , *args
			#check whether the property actuall exists

			is_setter = (method.to_s[-1] == '=')
			reference_symbol = method.to_s[-1] == '=' ? method.to_s.chop.to_sym : method
			super unless Cli_Yo.all_properties.include? reference_symbol
			if is_setter
				@arguments[reference_symbol] = args[0]
			else
				@arguments[reference_symbol]
			end
		end

		def property_is_set? property
			property = property.to_sym if property.class == String
			@arguments[property] != nil
		end
	end

	module Helper
		def self.consecutive_counter n
			suffix = "th"
			unless (n >= 10 && n <= 20) || n.to_s[-2] == '1'
				if n.to_s[-1] == '1'
					suffix = "st"
				elsif n.to_s[-1] == '2'
					suffix = "nd"
				elsif n.to_s[-1] == '3'
					suffix = 'rd'
				end
			end
			"#{n}-#{suffix}"
		end
	end

	def self.yo! arguments
		raise Yo_Error.new unless arguments.class == Hash || arguments.class == Yo_Arguments
		arguments = Yo_Arguments.new arguments if arguments.class == Hash
		begin

			Cli_Yo.mandatory_properties.each do |prop|
				raise Yo_Error.new "Missing mandatory argument #{prop}" unless arguments.property_is_set? (prop)
			end

			puts "Going to start yo-ing #{arguments.username}"
			Process.daemon if arguments.silent
			counter = arguments.count

			until counter <= 0 do
				result = RestClient.post YO_URL , {username: arguments.username , api_token: arguments.api_token}
				result = JSON.parse result , symbolize_names: true

				raise Yo_Error.new(result[:error] , result[:code]) if result[:code] || result[:error]

				puts "\nYo-ed #{arguments.username} ! This is the #{Helper::consecutive_counter (arguments.count - counter + 1)} Yo!" unless arguments.silent
				counter -= 1
				break if counter <= 0
				sleep arguments.interval * 60  #Yo allows at most 1 minutes once!
			end

			unless arguments.silent
				puts "\nCompleted your Yo-es with ultimate awesomeness!"
				puts "Add the silent option if you don't want this message to pop up!"
			end

		rescue Yo_Error => err
			puts err
		end
	end


end

