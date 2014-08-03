require "rest_client"
require "json"
YO_URL = "http://api.justyo.co/yo/"

module Cli_Yo

	@all_properties = [:silent , :times , :usernames , :api_token , :interval];
	@numeric_properties = [:times , :interval];
	@mandatory_properties = [:usernames , :api_token]

	class << self
		attr_reader :short_cut_mapping , :all_properties , :numeric_properties , :mandatory_properties
	end

	class Yo_Error < Exception
		attr_reader :error , :code

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

			@arguments[:times] ||= 1
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

		def self.beautiful_sentence arr
			return nil if arr.size == 0
			return arr[0] if arr.size == 1

			str = ""
			for i in 0...(arr.size - 1) do
				str += ", " unless i == 0
				str += "#{arr[i]}"
			end
			str = "#{str} and #{arr.last}"
		end
	end

	def self.yo! arguments

		raise Yo_Error.new "invalid arguments class provided!" unless arguments.class == Hash || arguments.class == Yo_Arguments
		arguments = Yo_Arguments.new arguments if arguments.class == Hash

		begin

			raise Yo_Error.new "Noone to yo!" if arguments.usernames.size == 0
			Cli_Yo.mandatory_properties.each do |prop|
				raise Yo_Error.new "Missing mandatory argument #{prop}" unless arguments.property_is_set? (prop)
			end

			puts "Going to start yo-ing #{Helper::beautiful_sentence(arguments.usernames)}"
			puts "Pid of current Process is #{Process.pid} "

			Process.daemon('./') if arguments.silent
			counter = arguments.times

			until counter <= 0 do
				arguments.usernames.each do |username|
					result = RestClient.post YO_URL , {username: username , api_token: arguments.api_token}
					result = JSON.parse result , symbolize_names: true
					raise Yo_Error.new(result[:error] , result[:code]) if result[:code] || result[:error]
				end
				puts "Yo-ed #{Helper::beautiful_sentence(arguments.usernames)} ! This is the #{Helper::consecutive_counter (arguments.times - counter + 1)} Yo!!" unless arguments.silent
				counter -= 1
				break if counter <= 0
				sleep arguments.interval * 60  #Yo allows at most 1 minutes once!
			end

			unless arguments.silent
				puts "\nCompleted your Yo-es with ultimate awesomeness!"
				puts "Add the silent option if you don't want these messages to pop up!"
			end

		rescue Yo_Error => err
			puts err
		end
	end
end