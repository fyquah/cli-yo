Gem::Specification.new do |s|
	s.name = "cli_yo"
	s.executables << "cli-yo"
	s.version = "0.0.1"
	s.date = "2014-08-03"
	s.summary = "A command line interface to send Yo!"
	s.description = "You can Yo anyone, while writing your magnificent code. The best part, you don't need to do anything! "
	s.author = "FY Quah"
	s.email = "quah.fy95@gmail.com"
	s.add_runtime_dependency "rest-client" , "1.7.2"
	s.add_runtime_dependency "json" , "1.8.1"
	s.add_runtime_dependency "mercenary" , "0.3.4"
	s.files = ["lib/cli_yo.rb" , "lib/cli_yo/helper.rb" , "lib/cli_yo/yo_arguments.rb" , "lib/cli_yo/yo_error.rb" , "bin/cli-yo"]
	s.homepage = 'https://github.com/fyquah95/cli-yo/'
end