require "rest_client"
YO_URL = "http://api.justyo.co/yo/"

module Properties

	@arguments = Hash.new
	@short_cut_mapping = {
		s: :silent,
		a: :api_token,
		c: :count
	}
	@all_properties = [:silent , :count , :username , :api_token];
	@numeric_properties = [:count];
	@all_properties.sort!

	class << self
		attr_reader :arguments
	end

	def self.initialize_arguments
		#Since username should be the first argument
		raise "No username given" if ARGV[0] =~ /\A--/ || ARGV[0] =~ /\A-/	
		reference_symbol = :username;
		ARGV.each do |argv|

			if argv =~ /\A--/
				reference_symbol = argv[2..-1].to_sym
				@arguments[reference_symbol] = true
			elsif argv =~ /\A-/ 
				reference_symbol = @short_cut_mapping[argv[1..-1].to_sym]
				@arguments[reference_symbol] = true
			else
				@arguments[reference_symbol] = argv
			end

			raise "Unkown property #{reference_symbol}" unless @all_properties.include? reference_symbol
		end

		@arguments[:api_token] ||= `echo $YO_TOKEN`.chomp
		raise "Do not know yo token" unless @arguments[:username]

		@numeric_properties.each do |key|
			@arguments[key].to_i! if @arguments[key]
		end

	end

	def self.method_missing method , *args
		#check whether the property actuall exists

		is_setter = (method.to_s[-1] == '=')
		reference_symbol = method.to_s[-1] == '=' ? method.to_s.chop.to_sym : method
		super unless @all_properties.include? reference_symbol
		if is_setter
			@arguments[reference_symbol] = args[0]
		else
			@arguments[reference_symbol]
		end
	end

	initialize_arguments

	@arguments.each do |hash , val|
		puts "#{hash} => #{val}"
	end

end