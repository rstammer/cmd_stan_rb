module Stan
  class Model
    class NoDataGivenError < StandardError ;; end

    attr_accessor :compiled_model_path, :name, :data
    attr_reader :model_string, :model_file

    class << self
      def load(name)
        new(name)
      end
    end

    def initialize(name, &block)
      @name = name
      @model_string = block.call if block_given?

      `mkdir -p #{model_directory}` unless Dir.exists?(model_directory)

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
      system(commands[:compile])
      {state: :ok, target: target, working_directory: working_directory}
    end

    def fit
      raise NoDataGivenError.new("Please specify your model's data before running simulations!") if data.nil?
      `chmod +x #{CmdStanRb.configuration.model_dir}/#{name}/#{name}`
      `#{commands[:fit]}`
      {state: :ok, data: data}
    end

    def show
      `#{CmdStanRb.configuration.cmdstan_dir}/bin/stansummary output.csv`
    end

    def destroy
      path = "#{CmdStanRb.configuration.model_dir}/#{name}"
      `rm -rvf #{path}`
      {state: :ok, destroyed_path: path}
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

  end
end
