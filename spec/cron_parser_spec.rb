require 'rspec'

require_relative '../cron_parser.rb'

RSpec.describe CronParser do
  context 'parsing basic fields' do
    it 'parses minute field with */15' do
      parser = CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/env")
      result = parser.parse
      expect(result['minute']).to eq('0 15 30 45')
    end

    it 'parses hour field with 1' do
      parser = CronParser.new("*/15 1 1,15 * 1-5 /usr/bin/env")
      result = parser.parse
      expect(result['hour']).to eq('1')
    end

    it 'parses month field with all months' do
      parser = CronParser.new("*/15 1 1,15 * 1-5 /usr/bin/env")
      result = parser.parse
      expect(result['month']).to eq('1 2 3 4 5 6 7 8 9 10 11 12')
    end
  end

  context 'parsing special characters' do
    it 'parses last day of month with L' do
      parser = CronParser.new("* * L * * /usr/bin/env")
      result = parser.parse
      expect(result['day of month']).to eq('31') # Assuming a 31-day month
    end
  end
end
