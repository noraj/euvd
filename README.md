# EUVD - Ruby library wrapper

[![GitHub forks](https://img.shields.io/github/forks/noraj/euvd)](https://github.com/noraj/euvd/network)
[![GitHub stars](https://img.shields.io/github/stars/noraj/euvd)](https://github.com/noraj/euvd/stargazers)
[![GitHub license](https://img.shields.io/github/license/noraj/euvd)](https://github.com/noraj/euvd/blob/master/LICENSE)

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/noraj/euvd/ruby.yml?branch=master)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/noraj/euvd)

![](https://noraj.github.io/euvd/_media/euvd-logo.png)

A Ruby wrapper library for the [European Union Vulnerability Database (EUVD)](https://euvd.enisa.europa.eu/apidoc) API. Uses the [Sawyer](https://github.com/lostisland/sawyer) HTTP agent framework.

All endpoints are **GET-only** and **require no authentication**.

## Installation

```bash
gem install euvd
```

Check the [installation](https://noraj.github.io/euvd/#/pages/install) page on the documentation to discover more methods.

[![Packaging status](https://repology.org/badge/vertical-allrepos/euvd.svg)](https://repology.org/project/euvd/versions)
[![Gem Version](https://badge.fury.io/rb/euvd.svg)](https://badge.fury.io/rb/euvd)
![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/noraj/euvd)

## Documentation

Homepage / Documentation: https://noraj.github.io/euvd/

## Usage

```ruby
require 'euvd'

client = EUVD::Client.new
```

### Vulnerabilities

Returns `Sawyer::Resource` objects (or `Array` of them). Access JSON fields as methods:

```ruby
results = client.vulnerabilities.latest
# => Array<Sawyer::Resource>
#    results.first.id, results.first.description, results.first.baseScore, ...

search = client.vulnerabilities.search(text: 'log4j', size: 10, page: 0)
# => Sawyer::Resource with .items (Array) and .total (Integer)
#    search.items.first.id, search.total

client.vulnerabilities.exploited
client.vulnerabilities.critical
```

Search filters: `text`, `fromScore` (0-10), `toScore`, `fromEpss` (0-100), `toEpss`, `fromDate` (YYYY-MM-DD), `toDate`, `fromUpdatedDate`, `toUpdatedDate`, `product`, `vendor`, `assigner`, `exploited` (true/false), `page` (starts at 0), `size` (default 10, max 100).

### Records

Returns `Sawyer::Resource` objects:

```ruby
record = client.records.find('EUVD-2025-20101')
# => Sawyer::Resource
#    record.id, record.description, record.baseScore, record.assigner, ...

# Also works with CVE or GHSA IDs
client.records.find('CVE-2025-47228')
client.records.find('GHSA-pfxq-29cx-gm9c')

advisory = client.records.advisory('oxas-adv-2024-0002')
# => Sawyer::Resource
```

### Downloads

```ruby
client.downloads.cve_euvd_mapping  # returns CSV String
client.downloads.kev_dump          # returns raw JSON String
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

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Made by Alexandre ZANNI ([@noraj](https://pwn.by/noraj/)).
