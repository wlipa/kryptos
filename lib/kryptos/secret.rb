class KryptosSecret < ActiveRecord::Base
  
  def gitignore_path
    "#{Rails.root}/.gitignore"
  end
  
  def cleartext_path
    "#{Rails.root}/config/kryptos.rb"
  end
  
  def encrypted_path
    "#{cleartext_path}.enc"
  end
  
  def clandestine_operations
    check_gitignore
    if File.exists? cleartext_path
      # If the encrypted version is out of date, regenerate it
      enc_mtime = File.exists?(encrypted_path) && File.mtime(encrypted_path)
      encrypt_secrets if !enc_mtime || enc_mtime < File.mtime(cleartext_path)
    else
      decrypt_secrets
    end
    require cleartext_path
  end
  
  def check_gitignore
    return unless Rails.env.development?
    to_ignore = "config/kryptos.rb"
    ignores = IO.read(gitignore_path)
    raise "gitignore must ignore #{to_ignore}" unless ignores =~ /^#{to_ignore}$/
  end
  
  def encrypt_secrets
    return unless Rails.env.development?
    Rails.logger.info "kryptos encrypt_secrets"
    cipher = Gibberish::AES.new(secret)
    IO.write(encrypted_path, cipher.encrypt(IO.read(cleartext_path)))
  end
  
  def decrypt_secrets
    Rails.logger.info "kryptos decrypt_secrets"
    cipher = Gibberish::AES.new(secret)
    IO.write(cleartext_path, cipher.decrypt(IO.read(encrypted_path)))
    prev_time = File.mtime(encrypted_path)
    File.utime(prev_time, prev_time, cleartext_path)    # avoid round-trip
  end
  
end
