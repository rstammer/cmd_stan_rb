class RubyStan::Model

  attr_accessor :compiled_model_path, :name, :data
  attr_reader :model_string, :model_file

  MODEL_DIR = "output"

  def initialize(name, &block)
    @name = name
    @model_string = block.call
    `mkdir -p #{MODEL_DIR}/#{name}`
    @model_file = File.open("#{MODEL_DIR}/#{name}/#{name}.stan", "w")
    @model_file.write(@model_string)
    @model_file.rewind
  end

  # Main interactions
  #
  #

  def compile
    cmd = "make -C #{RubyStan.configuration.cmdstan_dir} #{target}"
    system(cmd)
    {state: :ok, target: target}
  end

  def fit
    `chmod +x #{MODEL_DIR}/#{name}/#{name}`
    cmd = "#{MODEL_DIR}/#{name}/#{name} sample data file=#{data_file.path}"
    `#{cmd}`
    {state: :ok, data: data}
  end

  def show
    `#{RubyStan.configuration.cmdstan_dir}/bin/stansummary output.csv`
  end

  def destroy
    # TODO: Cleanup all files generates
    model_file.unlink
  end

  private

  def data_file
    file = File.open("#{MODEL_DIR}/#{name}/#{name}.json", "w")
    file.write(data.to_json)
    file.rewind
    file
  end

  def target
    "../../#{MODEL_DIR}/#{name}/#{name}"
  end
end
