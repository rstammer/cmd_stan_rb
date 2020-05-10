require "spec_helper"

RSpec.describe Stan::Model do

  before do
    allow_any_instance_of(described_class).to receive(:create_model_file!).and_return(nil)
  end

  describe "its constructor" do

    subject do
      described_class.new("bernoulli-test") do
        "The Stan code goes here!"
      end
    end

    it "needs a name and a block returning the Stan model as a string" do
      expect { subject }.not_to raise_error
    end

    it "sets the name" do
      expect(subject.name).to eql("bernoulli-test")
    end
  end

  describe "#load" do
    subject { described_class.load("my-model-1") }
    it { expect(subject.name).to eql("my-model-1") }
  end

end
