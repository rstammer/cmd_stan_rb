module Stan
  class Model
    class NoDataGivenError < StandardError ;; end
    class InvalidNameError < StandardError ;; end

    attr_accessor :data
    attr_reader :compiled_model_path, :model_string, :model_file,
                :name, :last_compiled_at

    class << self
      def load(name)
        new(name)
      end
    end

    def initialize(name, &block)
      raise InvalidNameError.new("Please ensure that the model name does not start with a number!") if (name.to_s =~ /^\d/)
      @name = name
      @model_string = block.call if block_given?

      FileUtils.mkdir_p(model_directory) unless Dir.exists?(model_directory)

      if File.exists?(filename)
        load_model_file
      else
        create_model_file!
      end
    end

    # Main interactions
    #
    #

    def compile
      if system(commands[:compile].to_s)
        @last_compiled_at = Time.now
        true
      else
        false
      end
    end

    def fit
      raise NoDataGivenError.new("Please specify your model's data before running simulations!") if data.nil?

      FileUtils.chmod(0755, "#{CmdStanRb.configuration.model_dir}/#{name}/#{name}")
      `#{commands[:fit].to_s}`

      Stan::FitResult.new(output_csv)
    end

    def show
      `#{CmdStanRb.configuration.cmdstan_dir}/bin/stansummary output.csv`
    end

    def destroy
      FileUtils.rm_rf(model_directory)
    end

    def commands
      {
        compile: "make -C #{CmdStanRb.configuration.cmdstan_dir} #{target}",
        fit: "#{CmdStanRb.configuration.model_dir}/#{name}/#{name} sample data file=#{data_file.path}"
      }
    end

    private

    def load_model_file
      @model_file = File.open(filename, "r")
      @model_string = @model_file.read
      @model_file.rewind
    end

    def create_model_file!
      @model_file = File.open(filename, "w")
      @model_file.write(@model_string)
      @model_file.rewind
    end

    def data_file
      file = File.open("#{CmdStanRb.configuration.model_dir}/#{name}/#{name}.json", "w")
      file.write(data.to_json)
      file.rewind
      file
    end

    def target
      "#{CmdStanRb.configuration.model_dir}/#{name}/#{name}"
    end

    def working_directory
      @wd ||= `pwd`.gsub("\n", "")
    end

    def model_directory
      "#{CmdStanRb.configuration.model_dir}/#{name}"
    end

    def filename
      "#{CmdStanRb.configuration.model_dir}/#{name}/#{name}.stan"
    end

    def output_csv
      File.read("output.csv")
    rescue
      ""
    end

  end
end
