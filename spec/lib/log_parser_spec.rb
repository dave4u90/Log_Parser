require_relative '../../lib/log_parser'

describe LogParser do
  let(:valid_file_path) { 'resources/webserver.log' }
  let(:invalid_file_path) { 'invalid_file_path' }
  let(:parser) { described_class.new(logfile: valid_file_path) }

  # LogParser.new(logfile: <file_path>)
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

  #[{ endpoint: '/home/2', entry_count: 10 }]
  xdescribe '#entry_counts_by_endpoint' do
    before { parser.parse }

    subject { parser.entry_counts_by_endpoint }
    
    it 'should return an array' do
      expect(subject.class).to eq Array
    end

    it 'should have a hash as each element in the array' do
      expect(subject.all? { |e| e.is_a? Hash }).to be_truthy
    end

    it 'should have expected keys in each hashes in the array' do
      expect(subject.all? { |e| e.keys == [:endpoint, :entry_count] }).to be_truthy
    end
  end

  #[{ endpoint: '/home', entry_count: 15 }]
  xdescribe '#entry_counts_by_controller_path' do
    before { parser.parse }

    subject { parser.entry_counts_by_controller_path }
    
    it 'should return an array' do
      expect(subject.class).to eq Array
    end

    it 'should have a hash as each element in the array' do
      expect(subject.all? { |e| e.is_a? Hash }).to be_truthy
    end

    it 'should have expected keys in each hashes in the array' do
      expect(subject.all? { |e| e.keys == [:controller_path, :entry_count] }).to be_truthy
    end
  end

  #[{ user_addr: '8.8.8.8', entry_count: 100 }]
  xdescribe '#entry_counts_by_user_addr' do
    before { parser.parse }

    subject { parser.entry_counts_by_user_addr }
    
    it 'should return an array' do
      expect(subject.class).to eq Array
    end

    it 'should have a hash as each element in the array' do
      expect(subject.all? { |e| e.is_a? Hash }).to be_truthy
    end

    it 'should have expected keys in each hashes in the array' do
      expect(subject.all? { |e| e.keys == [:user_addr, :entry_count] }).to be_truthy
    end
  end

  xdescribe '#sorted_endpoint_entries' do
    before do
      allow(parser).to receive(:entry_counts_by_endpoint).and_return(
        [
          { endpoint: 'endpoint1', entry_count: 50 },
          { endpoint: 'endpoint2', entry_count: 100},
          { endpoint: 'endpoint3', entry_count: 60 }
        ]
      )
    end

    subject { parser.sorted_endpoint_entries }

    it 'should return an array' do
      expect(subject.class).to eq Array
    end

    it 'should have a hash as each element in the array' do
      expect(subject.all? { |e| e.is_a? Hash }).to be_truthy
    end

    it 'should have expected keys in each hashes in the array' do
      expect(subject.all? { |e| e.keys == [:endpoint, :entry_count] }).to be_truthy
    end

    it 'should sort the entries by no of count in descending order' do
      expect(subject).to eq(
        [
          { endpoint: 'endpoint2', entry_count: 100},
          { endpoint: 'endpoint3', entry_count: 60 },
          { endpoint: 'endpoint1', entry_count: 50 }
        ]
      )
    end
  end

  xdescribe '#sorted_controller_path_entries' do
    before do
      allow(parser).to receive(:entry_counts_by_controller_path).and_return(
        [
          { controller_path: 'controller1', entry_count: 50 },
          { controller_path: 'controller2', entry_count: 100},
          { controller_path: 'controller3', entry_count: 60 }
        ]
      )
    end

    subject { parser.sorted_controller_path_entries }

    it 'should return an array' do
      expect(subject.class).to eq Array
    end

    it 'should have a hash as each element in the array' do
      expect(subject.all? { |e| e.is_a? Hash }).to be_truthy
    end

    it 'should have expected keys in each hashes in the array' do
      expect(subject.all? { |e| e.keys == [:controller_path, :entry_count] }).to be_truthy
    end

    it 'should sort the entries by no of count in descending order' do
      expect(subject).to eq(
        [
          { controller_path: 'controller2', entry_count: 100},
          { controller_path: 'controller3', entry_count: 60 },
          { controller_path: 'controller1', entry_count: 50 }
        ]
      )
    end
  end

  xdescribe '#sorted_user_addr_entries' do
    before do
      allow(parser).to receive(:entry_counts_by_user_addr).and_return(
        [
          { user_addr: '1.1.1.1', entry_count: 50 },
          { user_addr: '2.2.2.2', entry_count: 100 },
          { user_addr: '3.3.3.3', entry_count: 60 },
          { user_addr: '4.4.4.4', entry_count: 200 }
        ]
      )
    end

    subject { parser.sorted_user_addr_entries }

    it 'should return an array' do
      expect(subject.class).to eq Array
    end

    it 'should have a hash as each element in the array' do
      expect(subject.all? { |e| e.is_a? Hash }).to be_truthy
    end

    it 'should have expected keys in each hashes in the array' do
      expect(subject.all? { |e| e.keys == [:user_addr, :entry_count] }).to be_truthy
    end

    it 'should sort the entries by no of count in descending order and return top three' do
      expect(subject).to eq(
        [
          { user_addr: '4.4.4.4', entry_count: 200 },
          { user_addr: '2.2.2.2', entry_count: 100 },
          { user_addr: '3.3.3.3', entry_count: 60 }
        ]
      )
    end
  end
end