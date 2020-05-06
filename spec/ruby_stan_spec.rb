RSpec.describe RubyStan do
  it "has a version number" do
    expect(RubyStan::VERSION).not_to be nil
  end

  describe "its configuration variables" do
    it "knows where to search for CmdStan" do
      expect(RubyStan.configuration).to respond_to(:cmdstan_dir)
    end

    xit "can set CmdStan directory" do
      expect { RubyStan.configuration.cmdstan_dir = "~/somewhere" }
        .to change { RubyStan.configuration.cmdstan_dir }
        .to("~/somewhere")
    end
  end

  describe ".reset" do
    it { expect(described_class).to respond_to(:reset) }
  end

  describe ".build_binaries" do
    it { expect(described_class).to respond_to(:build_binaries) }
  end
end
