# Quick start

## Quick install

```bash
gem install euvd
```

## Default usage: library

```ruby
require 'euvd'

# Initialize client
client = EUVD::Client.new

# Search for a vuln
record = client.records.find('EUVD-2025-20101')

# Access attributes
record.description
record.baseScoreVector
```
