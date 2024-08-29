#!/usr/bin/env ruby

class CronParser
  FIELD_NAMES = ['minute', 'hour', 'day of month', 'month', 'day of week', 'command'].freeze
  MINUTE_RANGE = (0..59).to_a.freeze
  HOUR_RANGE = (0..23).to_a.freeze
  DAY_OF_MONTH_RANGE = (1..31).to_a.freeze
  MONTH_RANGE = (1..12).to_a.freeze
  DAY_OF_WEEK_RANGE = (0..6).to_a.freeze

  def initialize(cron_string)
    @cron_string = cron_string
    @fields = @cron_string.split
    validate_format!
    @command = @fields.pop if @fields.size == 6
  end

  def parse
    output = {}
    FIELD_NAMES.each_with_index do |field_name, index|
      output[field_name] = index < 5 ? parse_field(@fields[index], range_for_field(index)) : @command
    end
    output
  end

  def parse_field(field, range)
    return '' if field.nil?

    if field == '*'
      range.join(' ')
    elsif field.include?(',')
      field.split(',').flat_map { |f| parse_field(f, range) }.join(' ')
    elsif field.include?('-')
      range_part = field.split('-').map(&:to_i)
      validate_range!(range_part, range)
      (range_part[0]..range_part[1]).to_a.join(' ')
    elsif field.include?('/')
      base, step = field.split('/')
      step = step.to_i
      raise ArgumentError, "Step value must be greater than zero" if step <= 0
      if base == '*'
        range.select { |n| n % step == 0 }.join(' ')
      else
        raise ArgumentError, "Invalid step format"
      end
    elsif field.include?('L')
      '31' # Simplified assumption: Always returns the last day of the month as 31
    else
      validate_value!(field.to_i, range)
      field
    end
  end

  def range_for_field(index)
    case index
    when 0 then MINUTE_RANGE
    when 1 then HOUR_RANGE
    when 2 then DAY_OF_MONTH_RANGE
    when 3 then MONTH_RANGE
    when 4 then DAY_OF_WEEK_RANGE
    else []
    end
  end

  def validate_format!
    if @fields.size < 5 || @fields.size > 6
      raise ArgumentError, "Invalid cron format: Expected 5 fields plus an optional command"
    end
  end

  def validate_range!(range_part, range)
    if range_part.any? { |n| !range.include?(n) }
      raise ArgumentError, "Invalid range: #{range_part.join('-')} is out of bounds"
    end
  end

  def validate_value!(value, range)
    unless range.include?(value)
      raise ArgumentError, "Invalid value: #{value} is out of bounds"
    end
  end

  def print_output
    parse.each do |field, value|
      puts "#{field.ljust(14)}#{value}"
    end
  end
end

# Run the parser only if executed directly
if __FILE__ == $0
  if ARGV.empty?
    puts "Usage: #{$PROGRAM_NAME} 'cron_string'"
    exit(1)
  end

  cron_string = ARGV[0]
  begin
    parser = CronParser.new(cron_string)
    parser.print_output
  rescue ArgumentError => e
    puts "Error: #{e.message}"
  end
end
