$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end

