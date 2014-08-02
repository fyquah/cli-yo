#!/usr/bin/ruby
require "./properties.rb"

unless Properties.api_token
	puts "YO api_token not found! Please add the following line to your ~/.bashrc file! or include it in your arguments"
	puts "export $YO_TOKEN= <yo token obtained from api website> "
	exit
end

background_yo_process = fork do
	begin
		counter = Properties.count
		until counter == 0
			result = RestClient.post YO_URL , {username: Properties.username , api_token: Properties.api_token}
			result = JSON.parse result , symbolize_names: true

			raise Yo_Error result[:error] , result[:code] if result[:code] || result[:error]
			puts "\nYo-ed #{Properties.username} ! This is the #{Properties.consecutive_counter counter} Yo!" unless Properties.silent
			sleep Properties.interval  #Yo allows at most 1 minutes once!
			counter -= 1
		end

		unless Properties.complete_silent
			puts "\nCompleted your Yo-es with ultimate awesomeness!"
			puts "Add the --complete_silent option if you don't want this message to pop up!"
		end

		exit
	catch
		puts Yo_Error
	end	
end

Process.detach background_yo_process