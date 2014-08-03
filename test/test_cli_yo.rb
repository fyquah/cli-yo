require "test/unit"
require "cli_yo"

class Cli_YoTest < Test::Unit::TestCase
	def setup
		@yo_targets = ["fyquah95" , "fyquah"]
		@arguments = {
			usernames: @yo_targets,
		}
		$stdout = File.new "./test_log_file.log" , "w"
	end

	def teardown
		$stdout = STDOUT
	end

	def test_that_argument_is_raise_when_unkown_property_is_given_to_yo_argument_object
		argument_object = Yo_Arguments.new @arguments
		assert_raise { argument_object.awesome = "Haha" }
	end

	def test_that_raise_exception_when_non_existent_user_is_yo_ed
		Cli_Yo.yo! @arguments
		assert_block File.open("test_log_file.log") do |f|
			f.read.downcase.include? "error"
		end
	end
end