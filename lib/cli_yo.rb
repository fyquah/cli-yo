require "rest_client"
require "json"
YO_URL = "http://api.justyo.co/yo/"

module Cli_Yo
	class Yo_Error < StandardError
		def initialize error , code = nil
			@error = error
			@code = code
		end
	end

	@arguments = Hash.new
	@short_cut_mapping = {
		s: :silent,
		a: :api_token,
		c: :count , 
		i: :interval
	}
	@all_properties = [:silent , :count , :username , :api_token , :interval , :complete_silent];
	@numeric_properties = [:count , :interval];

	class << self
		attr_reader :arguments
	end

	def self.initialize_arguments
		#Since username should be the first argument
		raise "No username given" if ARGV[0] =~ /\A--/ || ARGV[0] =~ /\A-/ || ARGV.size == 0
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
		raise "Do not know yo token" unless @arguments[:api_token]

		@numeric_properties.each do |key|
			@arguments[key] = @arguments[key].to_i if @arguments[key]
		end

		# Granting some default values
		@arguments[:count] ||= 1
		@arguments[:interval] = 60.0 unless @arguments[:interval] && @arguments[:interval] > 60.0

		@arguments[:silent] = true if @arguments[:complete_silent]
		# @arguments[:interval] = 1 if  @arguments[:interval] < 1
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

	def self.consecutive_counter counter
		n = self.count - counter + 1
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