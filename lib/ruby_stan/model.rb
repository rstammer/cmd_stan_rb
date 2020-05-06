#  Example - bernoulli model: examples/bernoulli/bernoulli.stan
#
#     1. Build the model:
#        > make examples/bernoulli/bernoulli
#     2. Run the model:
#        > examples/bernoulli/bernoulli sample data file=examples/bernoulli/bernoulli.data.R
#     3. Look at the samples:
#        > bin/stansummary output.csv

#
# model = RubyStan::Model.new("b1") { RubyStan::Model::BERNOULLI_EXAMPLE }; model.data={"N" => 4, "y" => [0,1,0,0]}
class RubyStan::Model

  attr_accessor :compiled_model_path, :name, :data
  attr_reader :model_string, :model_file

  MODEL_DIR = "vendor/cmdstan/ruby_stan"

  def initialize(name, &block)
    @name = name
    @model_string = block.call
    `mkdir -p #{MODEL_DIR}/#{name}`
    @model_file = File.open("#{MODEL_DIR}/#{name}/#{name}.stan", "w")
    @model_file.write(@model_string)
    @model_file.rewind
  end

  def data_file
    file = Tempfile.new("#{name}.json")
    file.write(data.to_json)
    file.rewind
    file
  end

  def target
    "ruby_stan/#{name}/#{name}"
  end

  # Main interactions
  #
  #

  def compile
    cmd = "make -C #{RubyStan.configuration.cmdstan_dir} #{target}"
    puts cmd
    system(cmd)
  end

  def fit
    `#{MODEL_DIR}/#{name}/#{name} sample data file=#{data_file.path}`
  end

  def show
    system("#{RubyStan.configuration.cmdstan_dir}/bin/stansummary #{RubyStan.configuration.cmdstan_dir}/output.csv")
  end

  def destroy
    model_file.unlink
  end
end
