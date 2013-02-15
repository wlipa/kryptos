require 'kryptos/secret'
require 'kryptos/version'
require 'gibberish'

module Kryptos
  
  # Hook Rails init process
  class Railtie < Rails::Railtie
    initializer 'kryptos', :before => 'load_environment_config' do |app|
      ks = KryptosSecret.last rescue nil
      if ks
        ks.clandestine_operations
      else
        Rails.logger.info "no kryptos secret defined -- skipping"
      end
    end
  end
  
end
