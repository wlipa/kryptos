require 'kryptos/secret'
require 'kryptos/version'
require 'gibberish'

module Kryptos
  
  # Hook Rails init process
  class Railtie < Rails::Railtie
    initializer 'kryptos', :before => 'load_environment_config' do |app|
      KryptosSecret.new.clandestine_operations
    end
  end
  
end
