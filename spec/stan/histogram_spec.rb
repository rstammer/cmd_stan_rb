require "spec_helper"

RSpec.describe Stan::Histogram do

  subject { described_class.new(list) }

  describe "#to_h" do
    context "with integer values" do
      let(:list) { [1, 3, 3, 2, 2, 3, 3, 3] }

      it "counts occurrences and sorts keys" do
        expect(subject.to_h).to eql({1 => 1, 2 => 2, 3 => 5})
      end
    end

    context "with float values" do
      let(:list) { [1.0, 3.112, 3.113, 2.11, 2.11, 3.114, 3.115, 3.115] }

      it "counts occurrences and sorts keys" do
        expect(subject.to_h).to eql({
          1.0 => 1,
          2.11 => 2,
          3.112 => 1,
          3.113 => 1,
          3.114 => 1,
          3.115 => 2
        })
      end

      context "with bin_size set to 1" do
        subject { described_class.new(list, bin_size: 1) }

        it "counts occurrences and sorts keys" do
          expect(subject.to_h).to eql({
            1 => 1,
            2 => 2,
            3 => 5,
          })
        end
      end

      context "with bin_size set to 0.5" do
        subject { described_class.new(list, bin_size: 0.5) }

        it "counts occurrences and sorts keys" do
          expect(subject.to_h).to eql({
            1.0 => 1,
            2.0 => 2,
            3.0 => 5,
          })
        end
      end

      context "with bin_size set to 0.1" do
        subject { described_class.new(list, bin_size: 0.1) }

        it "counts occurrences and sorts keys" do
          expect(subject.to_h).to eql({
            1.0 => 1,
            2.1 => 2,
            3.1 => 5,
          })
        end
      end

      context "with bin_size set to 0.001" do
        subject { described_class.new(list, bin_size: 0.001) }

        it "counts occurrences and sorts keys" do
          expect(subject.to_h).to eql({
            1.0 => 1,
            2.11 => 2,
            3.112 => 1,
            3.113 => 1,
            3.114 => 1,
            3.115 => 2,
          })
        end
      end
    end
  end
end
