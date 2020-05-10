class RubyStan::Model
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

    # I'd like to invent a convenient DSL that
    # is similar to writing "direct" Stan code,
    # but to do so I need to get a better understanding
    # of Stan as a language/DSL itself. Until that
    # I "approximate" my goal by using a block for initialization,
    # where the block always needs to return the Stan model
    # as a string. You can load it from a file or write in directly!
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
    cmd = "make -C #{RubyStan.configuration.cmdstan_dir} #{target}"
    system(cmd)
    {state: :ok, target: target, working_directory: working_directory}
  end

  def fit
    raise NoDataGivenError.new("Please specify your model's data before running simulations!") if data.nil?
    `chmod +x #{RubyStan.configuration.model_dir}/#{name}/#{name}`
    cmd = "#{RubyStan.configuration.model_dir}/#{name}/#{name} sample data file=#{data_file.path}"
    `#{cmd}`
    {state: :ok, data: data}
  end

  def show
    `#{RubyStan.configuration.cmdstan_dir}/bin/stansummary output.csv`
  end

  def destroy
    path = "#{RubyStan.configuration.model_dir}/#{name}"
    `rm -rvf #{path}`
    {state: :ok, destroyed_path: path}
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
    file = File.open("#{RubyStan.configuration.model_dir}/#{name}/#{name}.json", "w")
    file.write(data.to_json)
    file.rewind
    file
  end

  def target
    "#{RubyStan.configuration.model_dir}/#{name}/#{name}"
  end

  def working_directory
    @wd ||= `pwd`.gsub("\n", "")
  end

  def model_directory
    "#{RubyStan.configuration.model_dir}/#{name}"
  end

  def filename
    "#{RubyStan.configuration.model_dir}/#{name}/#{name}.stan"
  end
end
