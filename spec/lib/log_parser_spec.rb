require_relative '../../lib/log_parser'

describe LogParser do
  let(:valid_file_path) { 'resources/webserver.log' }
  let(:invalid_file_path) { 'invalid_file_path' }
  let(:parser) { described_class.new(logfile: valid_file_path) }

  # LogParser.new(logfile: <file_path>)
  
  xdescribe 'initialization' do
    context 'with no logfile argument' do
      it 'should raise Argument error' do
        expect { described_class.new() }.to raise_error(ArgumentError)
      end
    end
  end

  xdescribe '#valid?' do
    subject { parser.valid? }

    context 'with valid path' do
      it 'should be valid with no errors' do
        expect(subject).to be_truthy
        expect(parser.errors).to be_nil
      end
    end

    context 'with invalid path' do
      let(:parser) { described_class.new(logfile: invalid_file_path) }

      it 'should be valid with no errors' do
        expect(subject).to be_falsey
        expect(parser.errors).to include('No such file or directory')
      end
    end
  end

  #[{ endpoint: '/home/2', controller_path: '/home', user_addr: '8.8.8.8' }]
  xdescribe '#parse' do
    subject { parser.parse }

    it 'should return an array' do
      expect(subject.class).to eq Array
    end

    it 'should have a hash as each element in the array' do
      expect(subject.all? { |e| e.is_a? Hash }).to be_truthy
    end

    it 'should have expected keys in each hashes in the array' do
      expect(subject.all? { |e| e.keys == [:endpoint, :controller_path, :user_addr] }).to be_truthy
    end
  end
end