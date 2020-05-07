module RubyStan
  class Configuration
    attr_accessor :cmdstan_dir

    def initialize
      self.cmdstan_dir = "vendor/cmdstan"
    end
  end
end
