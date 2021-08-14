require_relative '../../../lib/log_parser/log_entry_group'

describe LogParser::LogEntryGroup do
  describe '#initialize' do
    context 'without all the necessary parameters' do
      it 'expect to throw error' do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context 'with all parameters passed' do
      it 'should get initialized successfully' do
        expect { described_class.new(group_key: 'group_key', group_key_name: 'group_key_name', entry_count: 1) }.to_not raise_error
      end
    end
  end

  describe '#valid?' do
    let(:attributes) { {} }
    let(:log_entry_group) { described_class.new(**attributes) }

    context 'with invalid group_key_name' do
      let(:attributes) { super().merge(group_key: 'group_key', group_key_name: '', entry_count: 1) }

      it 'should be invalid' do
        expect(log_entry_group.valid?).to be_falsey
      end
    end

    context 'with invalid group_key' do
      let(:attributes) { super().merge(group_key: '', group_key_name: 'group_key_name', entry_count: 1) }

      it 'should be invalid' do
        expect(log_entry_group.valid?).to be_falsey
      end
    end

    context 'with invalid entry_count' do
      let(:attributes) { super().merge(group_key: '', group_key_name: 'group_key_name', entry_count: nil) }

      it 'should be invalid' do
        expect(log_entry_group.valid?).to be_falsey
      end
    end

    context 'with valid parameters' do
      let(:attributes) { super().merge(group_key: 'group_key', group_key_name: 'group_key_name', entry_count: 1) }

      it 'should be invalid' do
        expect(log_entry_group.valid?).to be_truthy
      end
    end
  end
end