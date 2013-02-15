# Kryptos

Kryptos provides a way to avoid checking in unencrypted application secrets such as API keys.  The secrets will be encrypted using a key stored in the database.  The assumption is that if an attacker can get to your database, you're in big trouble anyway.  But at least we can avoid giving away our API keys to people with access to the repository.  We still have to check in database access configuration, so you should use a firewall or equivalent to protect that.

Your typical workflow should be unaffected, as Kryptos handles decryption and encryption automatically.  The encrypted file will be version controlled and deployed.  There is a one time cost to set up the db secret, but after that, Kryptos should be out of your way.

Kryptos depends on Rails and has one gem dependency - the 'gibberish' library, which has no other dependencies. Kryptos itself is less than 100 lines of code and does not do any weird
monkeypatching.  So overhead should be quite light.


## Installation

Add this line to your application's Gemfile:

    gem 'kryptos'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kryptos


Next, add config/kryptos.rb to your .gitignore.  That's the main point of all this.  The gem checks that this file is ignored, so do that step now before even creating the file itself.

Add a migration for the KryptosSecrets table.  This table will contain one row with your randomly generated secret.  The migration should look like:

    class AddKryptosSecrets < ActiveRecord::Migration
      def change
        create_table :kryptos_secrets do |t|
          t.string :secret
        end
      end
    end

You can use OpenSSL or an equivalent tool to generate a random password.

    $ openssl rand -base64 32
    RANDOMSECRET

Then use the console to add your secret to the database.  Do not use 'RANDOMSECRET' literally; I hope that is obvious...

    $ rails console
    > KryptosSecret.create({ :secret => 'RANDOMSECRET'}, :without_protection => true)

Now create a file config/kryptos.rb that will contain the actual secrets.  This file can be any ruby code, for example:

    module AppSecrets
  
      AWS = Struct.new(:public_key, :private_key).new.tap do |s|
        s.public_key = "foo"
        s.private_key = "bar"
      end

    end

## Usage

Fire up the console again.  You should be able to access the config data:

    $ rails console
    > AppSecrets::AWS.public_key
    => "foo"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
