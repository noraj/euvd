# EUVD Ruby Gem

A Ruby wrapper library for the [European Union Vulnerability Database (EUVD)](https://euvd.enisa.europa.eu/apidoc) API. Uses the [Sawyer](https://github.com/lostisland/sawyer) HTTP agent framework.

All endpoints are **GET-only** and **require no authentication**.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'euvd'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself:

```bash
$ gem install euvd
```

## Usage

```ruby
require 'euvd'
client = EUVD::Client.new
```

### Vulnerabilities

```ruby
client.vulnerabilities.latest
client.vulnerabilities.exploited
client.vulnerabilities.critical
client.vulnerabilities.search(text: 'log4j', size: 10, page: 0)
```

Search filters: `text`, `fromScore` (0-10), `toScore`, `fromEpss` (0-100), `toEpss`, `fromDate` (YYYY-MM-DD), `toDate`, `fromUpdatedDate`, `toUpdatedDate`, `product`, `vendor`, `assigner`, `exploited` (true/false), `page` (starts at 0), `size` (default 10, max 100).

### Records

```ruby
client.records.find('EUVD-2024-45012')
client.records.find('CVE-2024-23187')
client.records.advisory('oxas-adv-2024-0002')
```

### Downloads

```ruby
client.downloads.cve_euvd_mapping  # returns CSV String
client.downloads.kev_dump          # returns Array of KEV entries
```

### Meta

```ruby
client.meta.assigners  # returns Array of assigner names
client.meta.banner     # returns Sawyer::Resource (enabled, message)
```

### Observations

```ruby
client.observations.honeypot_by_cve('CVE-2021-44228')
client.observations.honeypot_batch(%w[CVE-2021-44228 CVE-2021-45046])
client.observations.kev_by_cve('CVE-2021-44228')
client.observations.kev_batch('CVE-2021-44228')
```

### Error Handling

```ruby
begin
  record = client.records.find('EUVD-XXXX-XXXXX')
rescue EUVD::NotFoundError
  puts 'Not found'
rescue EUVD::RateLimitError
  puts 'Rate limited'
rescue EUVD::ServerError
  puts 'Server error'
rescue EUVD::BadResponseError
  puts 'Server returned non-JSON (likely down)'
rescue EUVD::Error => e
  puts "Error: #{e.message}"
end
```

### Configuration

```ruby
EUVD::Client.new(
  base_url: 'https://euvdservices.enisa.europa.eu/api'  # default
)
```

## Development

Run the tests:

```bash
bundle install
bundle exec rspec
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
