require "spec_helper"

module LenCLI
	describe 'LenCLI' do
		before { allow(Commander).to receive(:find_images_extract_gps) }

		describe '.version' do
			it "displays a version number" do
				expect { LenCLI::Interpreter.new.version }
					.to output(/Version: #{LenCLI::VERSION}/).to_stdout
			end
		end

		describe '.gps_grab' do
			let(:interpreter) { LenCLI::Interpreter.new }
			let(:subject) { interpreter.gps_grab }

			context 'search path parameter is not provided' do
				it 'passes nil search directory to the Commander' do
					expect(Commander)
						.to receive(:find_images_extract_gps).with(nil, nil)
					subject
				end
			end

			context 'Commander::CommanderError thrown' do
			 	before do
			 		allow(interpreter).to receive(:abort)
			 		allow(Commander)
						.to receive(:find_images_extract_gps)
						.and_raise(Commander::CommanderError)
			 	end
				
			 	it 'outputs a warning message to standard error' do
					expect(interpreter)
						.to receive(:abort).with("LenCLI::Commander::CommanderError")
					subject
			 	end
			end
		end
	end
end
