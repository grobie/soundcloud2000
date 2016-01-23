$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name          = "soundcloud2000"
  s.version       = "0.1.0"
  s.authors       = ["Tobias Schmidt", "Matthias Georgi"]
  s.email         = "matti.georgi@gmail.com"
  s.homepage      = "http://www.github.com/grobie/soundcloud2000"
  s.summary       = "SoundCloud without the stupid css files"
  s.description   = "The next generation SoundCloud client"
  s.license       = 'MIT'

  s.bindir        = 'bin'
  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "json", "~> 1.8"
  s.add_dependency "audite", "~> 0.4"
  s.add_dependency "curses", "~> 1.0"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 10.5"
  s.add_development_dependency "mocha", "~> 1.1"

  s.extra_rdoc_files = ["README.md"]
end
