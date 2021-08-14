require_relative '../../../lib/log_parser/log_entry'
require_relative '../../../lib/log_parser/log_entry_group'
require_relative '../../../lib/log_parser/log_entry_groups'

xdescribe LogParser::LogEntryGroups do
  let(:attributes) { {} }
  let(:log_entries) do
    [
      { controller_path: 'help_page', endpoint: '/help_page/1', user_addr: '126.318.035.038' },
      { controller_path: 'contact',  endpoint: '/contact', user_addr: '184.123.665.067' },
      { controller_path: 'home', endpoint: '/home', user_addr: '184.123.665.067' },
      { controller_path: 'about', endpoint:'/about/2', user_addr: '444.701.448.104' },
      { controller_path: 'help_page', endpoint: '/help_page/1', user_addr: '929.398.951.889' },
      { controller_path: 'index', endpoint: '/index', user_addr: '444.701.448.104' },
      { controller_path: 'help_page', endpoint: '/help_page/1', user_addr: '722.247.931.582' },
      { controller_path: 'about', endpoint: '/about', user_addr: '061.945.150.735' },
      { controller_path: 'help_page', endpoint: '/help_page/1', user_addr: '646.865.545.408' },
      { controller_path: 'home', endpoint: '/home', user_addr: '235.313.352.950' }
    ].map do |attributes|
      LogParser::LogEntry.new(**attributes)
    end
  end

  let(:log_entry_groups) { described_class.new(**attributes) }

  describe '#initialize' do
    context 'without all the necessary parameters' do
      it 'expect to throw error' do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context 'with all parameters passed' do
      it 'should get initialized successfully' do
        expect { described_class.new(log_entries: 'log_entries', group_by: 'group_by') }.to_not raise_error
      end
    end
  end

  describe '#valid?' do
    context 'with invalid parameters' do
      let(:attributes) { super().merge(log_entries: 'log_entries', group_by: 'group_by') }

      it 'should be invalid' do
        expect(log_entry_groups.valid?).to be_falsey
      end
    end

    context 'with all parameters' do
      context 'when valid' do
        let(:attributes) { super().merge(log_entries: log_entries, group_by: :endpoint) }

        it 'should be valid' do
          expect(log_entry_groups.valid?).to be_truthy
        end
      end

      context 'when group_by is not detected as a valid key to group' do
        let(:attributes) { super().merge(log_entries: log_entries, group_by: :unknown) }

        it 'should be invalid' do
          expect(log_entry_groups.valid?).to be_falsey
        end
      end

      context 'when collection of log entries is not an array' do
        let(:log_entries) { { a: 1 } }
        let(:attributes) { super().merge(log_entries: log_entries, group_by: :endpoint) }

        it 'should be invalid' do
          expect(log_entry_groups.valid?).to be_falsey
        end
      end

      context 'when collection of log entries is not correct' do
        let(:wrong_log_entry) { OpenStruct.new(controller_path: 'home', endpoint: '/home', user_addr: '235.313.352.950') }
        let(:log_entries) { super() << wrong_log_entry }

        let(:attributes) { super().merge(log_entries: log_entries, group_by: :endpoint) }

        it 'should be invalid' do
          expect(log_entry_groups.valid?).to be_falsey
        end
      end

      context 'when collection of log entries is an empty' do
        let(:log_entries) { [] }
        let(:attributes) { super().merge(log_entries: log_entries, group_by: :endpoint) }

        it 'should be invalid' do
          expect(log_entry_groups.valid?).to be_falsey
        end
      end
    end
  end

  describe '#perform' do
    context 'when invalid' do
      let(:wrong_log_entry) { OpenStruct.new(controller_path: 'home', endpoint: '/home', user_addr: '235.313.352.950') }
      let(:log_entries) { super() << wrong_log_entry }

      let(:attributes) { super().merge(log_entries: log_entries, group_by: :endpoint) }

      it 'should not group and return false' do
        expect(log_entry_groups.perform).to be_falsey
        expect(log_entry_groups.log_entry_groups).to be_empty
      end
    end

    context 'when a log entry is invalid' do
      let(:wrong_log_entry) { LogParser::LogEntry.new(controller_path: 'home', endpoint: '/home', user_addr: '') }
      let(:log_entries) { super() << wrong_log_entry }
      let(:attributes) { super().merge(log_entries: log_entries, group_by: :user_addr) }

      it 'should group with errors' do
        expect(log_entry_groups.perform).to be_falsey
        expect(log_entry_groups.errors).to eq([
          { type: 'LogParser::LogEntryGroup',
            message: "{:group_key=>\"\", :group_key_name=>:user_addr, :entry_count=>1} is not a valid log group"
          }
        ])
        expect(log_entry_groups.log_entry_groups).to_not be_empty
      end
    end

    context 'when sort group parameter is false' do
      let(:attributes) { super().merge(log_entries: log_entries, group_by: :endpoint) }

      it 'should group all the entries based on the group by key in unsorted manner' do
        expect(log_entry_groups.perform).to be_truthy
        expect(log_entry_groups.log_entry_groups).to_not be_empty
        expect(log_entry_groups.log_entry_groups.all? { |log_entry_group| log_entry_group.is_a? LogParser::LogEntryGroup }).to be_truthy
        entry_counts = log_entry_groups.log_entry_groups.map(&:entry_count)
        expect(entry_counts.sort.reverse).to_not eq(entry_counts)
      end
    end

    context 'when sort group parameter is true' do
      let(:attributes) { super().merge(log_entries: log_entries, group_by: :endpoint, sort_groups: true) }

      it 'should group all the entries based on the group by key in unsorted manner' do
        expect(log_entry_groups.perform).to be_truthy
        expect(log_entry_groups.log_entry_groups).to_not be_empty
        expect(log_entry_groups.log_entry_groups.all? { |log_entry_group| log_entry_group.is_a? LogParser::LogEntryGroup }).to be_truthy
        entry_counts = log_entry_groups.log_entry_groups.map(&:entry_count)
        expect(entry_counts.sort.reverse).to eq(entry_counts)
      end
    end
  end
end