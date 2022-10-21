module CmdStanRb
  class Configuration
    attr_accessor :cmdstan_dir
    attr_accessor :model_dir

    def initialize
      self.cmdstan_dir = "vendor/cmdstan"
      self.model_dir = "models"
    end
  end
end
