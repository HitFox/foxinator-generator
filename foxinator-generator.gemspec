Gem::Specification.new do |s|
  s.name        = "foxinator-generator"
  s.version     = "0.0.7"
  s.author      = "HitFox"
  s.email       = "peter@hitfoxgroup.com"
  s.homepage    = "https://github.com/HitFox/foxinator-generator"
  s.summary     = "Get your HitFox apps up and running quickly and easy!"
  s.description = "Installs an admin system, our customized CMS, and other goodies"

  s.files        = Dir["{lib,test}/**/*", "[A-Z]*"]
  s.require_path = "lib"

  # s.add_development_dependency 'rspec-rails', '~> 2.0.1'
  # s.add_development_dependency 'cucumber', '~> 0.9.2'
  s.add_development_dependency 'rails', '~> 4.2.0'
  # s.add_development_dependency 'devise', '~>3.4.1'
  # s.add_development_dependency 'state_machine', '~>1.2.0'
  # s.add_development_dependency 'inherited_resources', '~>1.6.0'
  # s.add_development_dependency 'rails_config', '~>0.4.2'
  # s.add_development_dependency 'comfortable_mexican_sofa', '~>1.12.8'
  # s.add_development_dependency 'mocha', '~> 0.9.8'
  # s.add_development_dependency 'bcrypt-ruby', '~> 2.1.2'
  # s.add_development_dependency 'sqlite3-ruby', '~> 1.3.1'

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
