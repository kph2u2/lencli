require "spec_helper"
require "lencli/services/callable/callable"

describe LenCLI::Callable do
  class CallableDouble
    attr_reader :options

    include LenCLI::Callable

    def initialize(options)
      @errors = options[:error] || []
      @options = options
    end

    def call
      self
    end
  end

  subject { CallableDouble.call(options) }
  let(:options) {{ one: :two, three: :four }}

  context "class call method" do
    it "returns an instance of itself" do
      expect(subject).to be_instance_of(CallableDouble)
    end

    it "passes original arguments to new instance" do
      expect(subject.options).to eql(options)
    end
  end

  context "an error is present" do
    let(:options) {{ error: ["There is an error."] }}

    it "causes instance method successful? to return false" do
      expect(subject.successful?).to be false
    end
  end

  context "an error is not present" do
    it "causes instance method successful? to return true" do
      expect(subject.successful?).to be true
    end
  end
end
