RSpec.describe CmdStanRb do
  it "has a version number" do
    expect(CmdStanRb::VERSION).not_to be nil
  end

  describe "its configuration variables" do
    it "knows where to search for CmdStan" do
      expect(CmdStanRb.configuration).to respond_to(:cmdstan_dir)
    end

    it "can set CmdStan directory" do
      expect { CmdStanRb.configuration.cmdstan_dir = "~/somewhere" }
        .to change { CmdStanRb.configuration.cmdstan_dir }
        .to("~/somewhere")
    end

    it "knows where to store models" do
      expect(CmdStanRb.configuration).to respond_to(:model_dir)
    end

    it "can set directory where to store models" do
      expect { CmdStanRb.configuration.model_dir = "~/somewhere-else" }
        .to change { CmdStanRb.configuration.model_dir }
        .to("~/somewhere-else")
    end
  end

  describe ".reset" do
    it { expect(described_class).to respond_to(:reset) }
  end

  describe ".build_binaries" do
    it { expect(described_class).to respond_to(:build_binaries) }
  end
end
