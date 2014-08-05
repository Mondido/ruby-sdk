$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mondido_sdk/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mondido_sdk"
  s.version     = MondidoSDK::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of MondidoSDK."
  s.description = "TODO: Description of MondidoSDK."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.3"

end
