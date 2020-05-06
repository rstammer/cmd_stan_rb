require "json"
require "tempfile"
require "ruby_stan/version"
require "ruby_stan/configuration"
require "ruby_stan/model"
require "ruby_stan/examples"

module RubyStan
  class Error < StandardError; end

  class << self
    attr_accessor :configuration

    def build_binaries
      system("make -C #{RubyStan.configuration.cmdstan_dir} build")
    end

    def reset
      system("make -C #{RubyStan.configuration.cmdstan_dir} clean-all")
    end
  end

  def self.configuration
    @configuration ||= RubyStan::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
