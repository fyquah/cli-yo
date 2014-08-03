require "rest_client"
require "json"
YO_URL = "http://api.justyo.co/yo/"

module Cli_Yo

	@all_properties = [:silent , :times , :usernames , :api_token , :interval];
	@numeric_properties = [:times , :interval];
	@mandatory_properties = [:usernames , :api_token]

	require "cli_yo/yo_arguments.rb"
	require "cli_yo/yo_error.rb"
	require "cli_yo/helper.rb"

	class << self
		attr_reader :short_cut_mapping , :all_properties , :numeric_properties , :mandatory_properties

		def yo! arguments

			raise Yo_Error.new "invalid arguments class provided!" unless arguments.class == Hash || arguments.class == Yo_Arguments
			arguments = Yo_Arguments.new arguments if arguments.class == Hash
			begin

				raise Yo_Error.new "Noone to yo!" if arguments.usernames.size == 0
				Cli_Yo.mandatory_properties.each do |prop|
					raise Yo_Error.new "Missing mandatory argument #{prop}" unless arguments.property_is_set? (prop)
				end

				puts "Going to start yo-ing #{Helper.beautiful_sentence(arguments.usernames)}"

				Process.daemon(true) if arguments.silent
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
end