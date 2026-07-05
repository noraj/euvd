# frozen_string_literal: true

require_relative 'euvd/version'
require_relative 'euvd/client'

# Load API resource modules
require_relative 'euvd/api/cve'
require_relative 'euvd/api/cpe'
require_relative 'euvd/api/cwe'
require_relative 'euvd/api/capec'
require_relative 'euvd/api/advisory'
require_relative 'euvd/api/statistics'
require_relative 'euvd/api/search'

module EUVD
end
