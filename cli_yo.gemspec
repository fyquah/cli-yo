Gem::Specification.new do |s|
	s.name = "cli_yo"
	s.executables << "yo"
	s.version = "0.0.0"
	s.date = "2014-08-02"
	s.summary = "A command line interface to send Yo!"
	s.description = "You can Yo anyone, while writing your magnificent code. The best part, you don't need to do anything! "
	s.author = "FY Quah"
	s.email = "quah.fy95@gmail.com"
	s.add_runtime_dependency "rest-client" , "1.7.2"
	s.add_runtime_dependency "json" , "1.8.1"
	s.files = ["./lib/cli_yo.rb" , "./bin/yo"]
	s.homepage = 'https://github.com/fyquah95/cli-yo/'
end