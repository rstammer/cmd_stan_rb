require "json"
require "cmd_stan_rb/version"
require "cmd_stan_rb/configuration"
require "stan"

module CmdStanRb
  class Error < StandardError; end

  class << self
    attr_accessor :configuration

    def build_binaries
      system("make -C #{CmdStanRb.configuration.cmdstan_dir} build")
    end

    def reset
      system("make -C #{CmdStanRb.configuration.cmdstan_dir} clean-all")
    end
  end

  def self.configuration
    @configuration ||= CmdStanRb::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
