require_relative '../../../lib/log_parser/parser'

xdescribe LogParser::Parser do
  let(:valid_file_path) { 'resources/webserver.log' }
  let(:invalid_file_path) { 'invalid_file_path' }
  let(:parser) { described_class.new(logfile: valid_file_path) }

  describe 'initialization' do
    context 'with no logfile argument' do
      it 'should raise Argument error' do
        expect { described_class.new() }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#valid?' do
    subject { parser.valid? }

    context 'with valid path' do
      it 'should be valid with no errors' do
        expect(subject).to be_truthy
        expect(parser.errors).to be_empty
      end
    end

    context 'with invalid path' do
      let(:parser) { described_class.new(logfile: invalid_file_path) }

      it 'should be valid with no errors' do
        expect(subject).to be_falsey
        expect(parser.errors).to include(
          { message: 'No such file or directory @ rb_sysopen - invalid_file_path',
            type: 'InvalidFilePath'
          }
        )
      end
    end
  end

  describe '#perform' do
    before { parser.perform }

    context 'when parser in invalid' do
      let(:parser) { described_class.new(logfile: invalid_file_path) }

      it 'should not create any log entries' do
        expect(parser.log_entries).to be_empty
      end
    end

    context 'when parser is valid' do
      it 'should create log entries' do
        expect(parser.log_entries).to_not be_empty
      end

      it 'each element in the log entries should be LogParser::LogEntry object' do
        expect(parser.log_entries.all? {|entry| entry.is_a? LogParser::LogEntry}).to be_truthy
      end
    end

    context 'when log entries have errors' do
      let(:valid_file_path) { 'resources/webserver1.log' }

      it 'should create log entries' do
        expect(parser.log_entries).to_not be_empty
      end

      it 'each element in the log entries should be LogParser::LogEntry object' do
        expect(parser.log_entries.all? {|entry| entry.is_a? LogParser::LogEntry}).to be_truthy
      end

      it 'should add error for entries for which are not valid' do
        expect(parser.errors.count).to eq(2)
      end

      it 'generates the error with proper format' do
        expect(parser.errors.all? { |error| error.keys == [:type, :message] }).to be_truthy
      end
    end
  end
end