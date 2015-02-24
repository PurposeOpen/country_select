# -*- encoding: utf-8 -*-
require File.expand_path('../lib/purpose_country_select/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian Guthrie"]
  gem.email         = ["btguthrie@gmail.com"]
  gem.description   = %q{Provides country_select functionality specifically geared to Purpose's needs}
  gem.summary       = %q{Specifically: different lists for donations and signups; customize the list of countries}
  gem.homepage      = "https://github.com/PurposeTW/purpose_country_select"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "purpose_country_select"
  gem.require_paths = ["lib"]
  gem.version       = PurposeCountrySelect::VERSION
  gem.add_dependency "actionpack", "> 3.2.0"
  gem.add_dependency "activesupport", "> 3.2.0"
  gem.add_dependency "sort_alphabetical"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-html-matchers"
  gem.add_development_dependency "stickler", "~> 2.2.4"
end
