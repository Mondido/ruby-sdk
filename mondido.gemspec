$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mondido/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mondido"
  s.version     = Mondido::VERSION
  s.authors     = ["Robert Falkén"]
  s.email       = ["falken@mondido.com"]
  s.homepage    = "TODO"
  s.summary     = "Library for making payments with Mondido"
  s.description = "TODO: Description of Mondido."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'

end
