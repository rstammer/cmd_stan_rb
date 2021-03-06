﻿require "spec_helper"

RSpec.describe Stan::FitResult do
  let(:output) { File.read("spec/fixtures/output.csv") }
  subject { described_class.new(output) }

  it { expect(subject.parameters).to eql(["alpha", "beta", "sigma"]) }

  describe "autogenerated parameter histograms" do
    it { expect(subject.alpha).to be_a Hash }
    it { expect(subject.beta).to be_a Hash }
    it { expect(subject.sigma).to be_a Hash }
  end
end
