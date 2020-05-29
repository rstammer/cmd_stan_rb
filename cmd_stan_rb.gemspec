require_relative 'lib/cmd_stan_rb/version'

Gem::Specification.new do |spec|
  spec.name          = "cmd_stan_rb"
  spec.version       = CmdStanRb::VERSION
  spec.authors       = ["Robin Neumann\n"]
  spec.email         = ["robin.neumann@posteo.de"]

  spec.summary       = %q{Ruby interface to CmdStan, the command line interface to Stan, a high performance statistical computing platform}
  spec.description   = %q{Stan is a state-of-the-art platform for statistical modeling and high-performance statistical computation. Thousands of users rely on Stan for statistical modeling, data analysis, and prediction in the social, biological, and physical sciences, engineering, and business. CmdStanRb offers bindings in Ruby to employ Stan, targeting easing up the integration of Stan and Bayesian Inference into Ruby-powered environments.}
  spec.homepage      = "https://github.com/neumanrq/cmd_stan_rb"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/neumanrq/cmd_stan_rb"
  spec.metadata["changelog_uri"] = "https://github.com/neumanrq/cmd_stan_rb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
end
