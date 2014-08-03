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
