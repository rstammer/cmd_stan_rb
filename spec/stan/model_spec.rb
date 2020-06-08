require "spec_helper"

RSpec.describe Stan::Model do
  before do
    allow_any_instance_of(described_class).to receive(:create_model_file!).and_return(nil)
  end

  subject do
    described_class.new("bernoulli-test") do
      Stan::Examples.bernoulli
    end
  end

  describe "its constructor" do
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

  describe "#compile" do
    context "when compilation suceeds" do
      before do
        expect(subject).to receive(:system).and_return(true)
        allow(subject).to receive(:commands).and_return({})
      end

      it { expect(subject.compile).to be_truthy }

      it "sets timestamp" do
        expect { subject.compile }.to change { subject.last_compiled_at }.from(nil)
      end
    end

    context "when compilation went wrong" do
      before do
        expect(subject).to receive(:system).and_return(false)
        allow(subject).to receive(:commands).and_return({})
      end

      it { expect(subject.compile).to be_falsey }

      it "sets timestamp" do
        expect { subject.compile }.to keep { subject.last_compiled_at }
      end
    end
  end

  describe "#fit" do
    context "without data given" do
      it "raises an error" do
        expect { subject.fit }.to raise_error(described_class::NoDataGivenError)
      end
    end
  end
end
