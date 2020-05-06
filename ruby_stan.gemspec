require_relative 'lib/ruby_stan/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_stan"
  spec.version       = RubyStan::VERSION
  spec.authors       = ["Robin Neumann\n"]
  spec.email         = ["robin.neumann@posteo.de"]

  spec.summary       = %q{Ruby bindings for Stan, a high performance statistical computing platform}
  spec.description   = %q{Stan is a state-of-the-art platform for statistical modeling and high-performance statistical computation. Thousands of users rely on Stan for statistical modeling, data analysis, and prediction in the social, biological, and physical sciences, engineering, and business. RubyStan offers bindings in Ruby to Stan.}
  spec.homepage      = "https://github.com/neumanrq/ruby_stan"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "rubygems"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/neumanrq/ruby_stan"
  spec.metadata["changelog_uri"] = "https://github.com/neumanrq/ruby_stan"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
