require "spec_helper"
require "lencli/services/file_matcher"

describe LenCLI::FileMatcher do
  describe ".call" do
    let(:subject) { described_class.call(options) }
    let(:options) {{ search_path: search_path, file_types: file_types }}
    let(:search_path) { "/usr/home/me" }
    let(:file_types) { nil }
    let(:results) { ["file_1.jpg", "file_2.jpg", "file_3.jpg"] }
    before do
      allow(Dir).to receive(:exists?).and_return(true)
      allow(Dir).to receive(:glob).and_return([])
    end

    context 'the requested search directory does not exist' do
      before { allow(Dir).to receive(:exists?).and_return(false) }

      it 'raises an error with a message specifying the missing directory' do
        expect(subject.errors)
          .to eq(["#{search_path} is not a valid directory to search"])
      end
    end

    context 'the requested directory exists' do
      context 'when search path parameter is provided' do
        it 'passes the provided search path to FileMatcher' do
          expect(Dir).to receive(:glob).with(/#{search_path}/)
          subject
        end
      end

      context 'when search path parameter is not provided' do
        let(:options) {{ file_types: file_types }}

        it 'passes the current directory to FileMatcher' do
          expect(Dir).to receive(:glob).with(".//**/*.{jpg}")
          subject
        end
      end

      context 'when an optional file type is not provided' do
        let(:options) {{ search_path: search_path }}

        it 'passes the default value "jpg" to FileMatcher' do
          expect(Dir).to receive(:glob).with(/jpg/)
          subject
        end
      end

      context 'when an optional file type is provided' do
        let(:file_types) { "png" }

        it 'passes the provided file type to FileMatcher' do
          expect(Dir).to receive(:glob).with(/png/)
          subject
        end
      end
    end

    context 'no files found for a given file suffix' do
      before { allow(Dir).to receive(:glob).and_return([]) }

      it 'returns an error with correct message' do
        expect(subject.errors)
          .to eql(["No files found with suffix(es) jpg under /usr/home/me"])
      end
    end

    context 'when files are found for a given file suffix' do
      before { allow(Dir).to receive(:glob).and_return(results) }

      it 'sets the file list with results' do
        expect(subject.file_list).to eql(results)
      end
    end
  end
end
