require "spec_helper"
require "lencli/services/action_output_service"
require "lencli/actions/gps_extraction_action"
require "lencli/output/html_action_output"
require "lencli/output/csv_action_output"

describe LenCLI::ActionOutputService do
  describe ".call" do
    let(:subject) { described_class.call(gps_search_action, options) }

    let(:gps_search_action) { double(LenCLI::GPSExtractionAction) }
    let(:output_action) { double(LenCLI::HtmlActionOutput) }

    let(:options) {{ output_format: output_format, output_path: output_path }}
    let(:output_format) { "html" }
    let(:output_path) { "/usr/home/me/output.html" }

    let(:file) { double(File) }

    let(:file_contents) { "My file contents." }

    before do
      allow(File)
        .to receive(:open).and_return(file)
      allow(file)
        .to receive(:write)
      allow(file)
        .to receive(:close)

      allow(LenCLI::HtmlActionOutput)
        .to receive(:new).and_return(output_action)
      allow(output_action)
        .to receive(:output).and_return(file_contents)
    end

    context "output path represents an accessible file" do
      it "opens the specified file" do
        expect(File).to receive(:open).with(output_path, "w")
        subject
      end
    end

    context "output path is a directory" do
      before { allow(File).to receive(:open).and_raise(Errno::EISDIR) }

      it "sets an appropriate error message" do
        expect(subject.errors)
          .to eql(["Cannot write to #{output_path} as it's a directory."])
      end
    end

    context "output path lacks permissions" do
      before { allow(File).to receive(:open).and_raise(Errno::EACCES) }

      it "sets an appropriate error message" do
        expect(subject.errors)
          .to eql(["Cannot write to #{output_path} due to permissions."])
      end
    end

    context "output format is specified" do
      context "as html" do
        before do
          allow(LenCLI::HtmlActionOutput)
            .to receive(:new).and_return(output_action)
        end

        it "uses HtmlActionOutput to create file contents" do
          expect(LenCLI::HtmlActionOutput)
            .to receive(:new).with(gps_search_action, output_path)
          subject
        end

        it "writes the formatted content to file" do
          expect(file).to receive(:write).with(file_contents)
          subject
        end
      end

      context "as csv" do
        let(:output_format) { "csv" }
        before do
          allow(LenCLI::CsvActionOutput)
            .to receive(:new).and_return(output_action)
        end

        it "uses CsvActionOutput to create file contents" do
          expect(LenCLI::CsvActionOutput)
            .to receive(:new).with(gps_search_action, output_path)
          subject
        end

        it "writes the formatted content to file" do
          expect(file).to receive(:write).with(file_contents)
          subject
        end
      end
    end
  end
end
