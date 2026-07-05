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

### Client instantiation

```ruby
require 'euvd'

client = EUVD::Client.new
```

### Client options

Most of these options should not be changed from the default.

```ruby
client = EUVD::Client.new(
  base_url:      'https://euvd.enisa.europa.eu/api/v1/',  # API base URL
  media_type:    :json,            # Response format (:json or :xml)
  auto_paginate: false,            # Automatically fetch all pages
  per_page:      20,               # Results per page (max: 100)
  faraday:       {},               # Faraday connection options
  headers:       {}                # Additional default headers
)
```

### CVE (Common Vulnerabilities and Exposures)

```ruby
# Get a specific CVE by ID
cve = client.cve.find('CVE-2021-44228')
puts cve.id         # => "CVE-2021-44228"
puts cve.summary    # => "Apache Log4j2 JNDI features..."
puts cve.severity   # => "CRITICAL"
puts cve.cvss_score # => 10.0

# Search CVEs with a query string
results = client.cve.search('apache log4j')

# Search with hash parameters
results = client.cve.search(q: 'linux kernel', severity: 'HIGH')

# List CVEs with pagination
results = client.cve.list(per_page: 50, page: 1)

# Get recent CVEs
recent = client.cve.recent(limit: 10)
```

### CPE (Common Platform Enumeration)

```ruby
# Find a specific CPE
cpe = client.cpe.find('cpe:2.3:a:apache:log4j:*:*:*:*:*:*:*:*')

# Search CPEs
results = client.cpe.search('apache')

# List CPEs
results = client.cpe.list(per_page: 20)
```

### CWE (Common Weakness Enumeration)

```ruby
# Find a specific CWE
cwe = client.cwe.find('CWE-79')

# Search CWEs
results = client.cwe.search('cross-site')
```

### CAPEC (Common Attack Pattern Enumeration and Classification)

```ruby
# Find a specific CAPEC
capec = client.capec.find('CAPEC-10')

# Search CAPECs
results = client.capec.search('buffer overflow')
```

### Advisories

```ruby
# Find a specific advisory
advisory = client.advisory.find('ADV-2024-001')

# Search advisories
results = client.advisory.search('apache')

# List advisories
results = client.advisory.list(per_page: 20)
```

### Statistics

```ruby
# Get summary statistics
stats = client.statistics.summary

# CVEs by severity
by_severity = client.statistics.cve_by_severity

# CVEs by year
by_year = client.statistics.cve_by_year

# Top vendors
top_vendors = client.statistics.top_vendors(limit: 10)

# Top products
top_products = client.statistics.top_products(limit: 10)

# CWEs by occurrence
cwe_by_occurrence = client.statistics.cwe_by_occurrence(limit: 20)
```

### Search (cross-entity)

```ruby
# Search across all entities
results = client.search.all(q: 'apache')

# Search within specific entities
cves        = client.search.cve(q: 'log4j')
cpes        = client.search.cpe(q: 'apache')
cwes        = client.search.cwe(q: 'XSS')
capeks      = client.search.capec(q: 'injection')
advisories  = client.search.advisory(q: 'security')
```

### Pagination

```ruby
# Automatic pagination (collects all pages)
all_cves = client.paginate('cve', q: 'apache', per_page: 100)

# With a block (yields each item)
client.paginate('cve', q: 'apache') do |cve|
  puts cve.id
end
```

### Raw GET requests

```ruby
response = client.get('path/to/resource')
response.data    # Sawyer::Resource or Array of Resources
response.status  # HTTP status code (e.g. 200)
response.headers # Response headers hash
response.rels    # Link relations from Link header
```

### Error handling

```ruby
begin
  cve = client.cve.find('CVE-0000-0000')
rescue EUVD::NotFoundError => e
  puts "Not found: #{e.message}"
rescue EUVD::RateLimitError => e
  puts "Rate limited: #{e.message}"
rescue EUVD::ServerError => e
  puts "Server error: #{e.message}"
rescue EUVD::Error => e
  puts "EUVD error: #{e.message}"
end
```

## Development

After checking out the repo, install dependencies:

```bash
$ bundle install
```

Run the tests:

```bash
$ bundle exec rspec
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
