# Kryptos

Kryptos provides a way to avoid checking in unencrypted application secrets such as
API keys.  The secrets will be encrypted using a file based key stored on your
development machine.

Your typical workflow should be unaffected, as Kryptos handles decryption and
encryption automatically.  The encrypted file will be version controlled and deployed.

Kryptos depends on Rails and has one gem dependency - the 'gibberish' library, which
has no other dependencies. Kryptos itself is less than 100 lines of code and does
not do any weird monkeypatching.  So overhead should be quite light.


## Installation

Add this line to your application's Gemfile:

    gem 'kryptos'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kryptos

Next, remove config/secrets.yml from git and add the following entries to your .gitignore:

    config/secrets.yml
    config/kryptos.key

You can use OpenSSL or an equivalent tool to generate a random password.

    $ openssl rand -base64 48 > config/kryptos.key

Now put your secrets into config/secrets.yml (which should not be tracked by git any more).

    development:
      secret_key_base: 3b7cd727aa24e8444053437c36cc66c3
      sample_api_key: DUMMY


## Usage

Fire up the console again.  You should be able to access the config data:

    $ rails console
    > Rails.application.secrets.sample_api_key
    => "DUMMY"

The krytos gem comes with a capistrano task to simplify deploying the key file.
Add this line to your Capfile:

    require 'kryptos/capistrano'

