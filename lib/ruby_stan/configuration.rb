module RubyStan
  class Configuration
    attr_accessor :cmdstan_dir

    def initialize
      cmdstan_dir = "~/private_projects/cmdstan"
    end
  end
end
