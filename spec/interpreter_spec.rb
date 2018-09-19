require "spec_helper"
require "lencli/interpreter/interpreter"

describe "LenCLI::Interpreter" do
  describe ".version" do
    it "displays a version number" do
      expect { LenCLI::Interpreter.new.version }
        .to output(/Version: #{LenCLI::VERSION}/).to_stdout
    end
  end

  describe ".gps_grab" do
    before { allow(LenCLI::Commander).to receive(:gps_grab) }

    let(:interpreter) { LenCLI::Interpreter.new }
    let(:subject) { interpreter.gps_grab }

    context "optional search path parameter is not provided" do
      it "passes nil search directory to the Commander" do
        expect(LenCLI::Commander)
          .to receive(:gps_grab)
          .with(hash_including(search_path: nil))
        subject
      end
    end

    context "Commander::CommanderError thrown" do
      before do
        allow(interpreter).to receive(:abort)
        allow(LenCLI::Commander)
          .to receive(:gps_grab)
          .and_raise(LenCLI::Commander::CommanderError)
      end
      
      it "outputs a warning message to standard error" do
        expect(interpreter)
          .to receive(:abort).with(/LenCLI::Commander::CommanderError/)
        subject
      end
    end
  end
end
