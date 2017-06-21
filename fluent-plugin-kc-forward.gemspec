Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-kc-forward"
  gem.version       = "0.1"
  gem.authors       = ["Casey Vu"]
  gem.email         = ["vuanhthu888@gmail.com"]
  gem.description   = %q{extension of fluentd in/out_forward}
  gem.summary       = %q{extend fluentd in/out_forward to accept shared_key_file in security section}
  gem.homepage      = "https://github.com/caseyvu/fluent-plugin-kc-forward"
  gem.license       = "Apache-2.0"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "fluentd"
  gem.add_development_dependency "rake"
  #gem.add_development_dependency "test-unit"
end
