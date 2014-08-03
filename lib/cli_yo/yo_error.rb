module Cli_Yo
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
end