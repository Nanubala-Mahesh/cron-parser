# CronParser

CronParser is a Ruby command-line application that parses and expands a cron string to show the specific times at which it will run. It supports basic cron fields and special characters like `*`, `-`, `/`, and `L`.

## Features

- **Parse cron strings**: Expands cron fields like minute, hour, day of month, month, and day of week.
- **Support for special characters**: Handles common cron expressions such as `*/15`, `1-5`, and `L` for the last day of the month.
- **Command-line interface**: Easily parse cron strings by providing them as arguments.

## Usage

### Command Line

To use the CronParser via the command line, run the following command:

```bash
./cron_parser.rb "*/15 0 1,15 * 1-5 /usr/bin/env"
```

This will output the expanded cron fields:

```
minute        0 15 30 45
hour          0
day of month  1 15
month         1 2 3 4 5 6 7 8 9 10 11 12
day of week   1 2 3 4 5
command       /usr/bin/env
```

### Testing 

The project uses RSpec for testing. To run the tests, use the following command:

```bash
rspec spec/cron_parser_spec.rb
```

### Example Test Cases

The tests cover various cases:

1. Parsing simple fields:
   - `*/15` for minute field expands to `0 15 30 45`.
   - `1` for hour field stays as `1`.
   - `*` for month field expands to `1 2 3 4 5 6 7 8 9 10 11 12`.
   
2. Parsing special characters:
   - `L` for the day of month field is simplified to `31` (assuming a 31-day month).

## Project Structure

- `cron_parser.rb`: The main script containing the `CronParser` class.
- `spec/cron_parser_spec.rb`: RSpec tests for the CronParser class.
- `Gemfile`: Gemfile has the dependency gems.

## Installation


1. **Clone the repository**:
   ```bash
   git clone git@github.com:Nanubala-Mahesh/cron-parser.git
   cd cron_parser
   ```

2. **Install dependencies**:
   Make sure you have Ruby installed. If not, install it from [Ruby's official website](https://www.ruby-lang.org/).

3. **Install required gems**:
   Run the following command to install the necessary dependencies:
   ```bash
   bundle install
   ```

4. **Run the parser**:
   Use the `cron_parser.rb` script to parse cron strings as shown below:
   ```bash
   ruby cron_parser.rb "*/15 2 1,15 * 2 /usr/bin/env"
   ```

5. **Run the tests**:
   To run the specs, use the following command:
   ```bash
   bundle exec rspec
   ```
