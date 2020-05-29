require "spec_helper"

RSpec.describe Stan::FitResult do
  let(:output) { File.read("spec/fixtures/output.csv") }
  subject { described_class.new(output) }

  describe "#iruby" do
    it "can print beatiful text summary for iruby" do
      pending "IMPLEMENT ME"
      expect(subject.for_iruby.summary).to include("alpha")
    end

    it "can print beatiful text summary for iruby" do
      pending "IMPLEMENT ME"
      expect(subject.for_iruby.plot_all).not_to be_nil
    end

    it "prints histogram for every parameter" do
      pending "IMPLEMENT ME"
      expect(subject.for_iruby.plot(:alpha, :beta)).not_to be_nil
    end
  end
end
