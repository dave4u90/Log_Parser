require_relative '../../../lib/log_parser/log_entry'

describe LogParser::LogEntry do
  describe '#initialize' do
    context 'without all the necessary parameters' do
      it 'expect to throw error' do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context 'with all parameters passed' do
      it 'should get initialized successfully' do
        expect { described_class.new(endpoint: 'endpoint', controller_path: 'controller_path', user_addr: 'user_addr') }.to_not raise_error
      end
    end
  end

  describe '#controller_path' do
    let(:log_entry) { described_class.new(endpoint: '/home/1', controller_path: 'home', user_addr: '8.8.8.8') }

    it 'should append a / with the controller path' do
      expect(log_entry.controller_path).to eq('/home')
    end
  end

  describe '#valid?' do
    let(:attributes) { {} }
    let(:log_entry) { described_class.new(**attributes) }

    context 'with invalid user_addr' do
      let(:attributes) { super().merge(endpoint: '/home/1', controller_path: '/home', user_addr: nil) }

      it 'should be invalid' do
        expect(log_entry.valid?).to be_falsey
      end
    end

    context 'with invalid controller path' do
      let(:attributes) { super().merge(endpoint: '/home/1', controller_path: '', user_addr: '8.8.8.8') }

      it 'should be invalid' do
        expect(log_entry.valid?).to be_falsey
      end
    end

    context 'with invalid endpoint' do
      let(:attributes) { super().merge(endpoint: '', controller_path: '/home', user_addr: '8.8.8.8') }

      it 'should be invalid' do
        expect(log_entry.valid?).to be_falsey
      end
    end

    context 'with valid parameters' do
      let(:attributes) { super().merge(endpoint: '/home/1', controller_path: '/home', user_addr: '8.8.8.8') }

      it 'should be invalid' do
        expect(log_entry.valid?).to be_truthy
      end
    end
  end
end