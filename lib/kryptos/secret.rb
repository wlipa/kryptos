class KryptosSecret

  def initialize
  end

  def gitignore_path
    "#{Rails.root}/.gitignore"
  end

  def relative_cleartext_path
    "config/secrets.yml"
  end

  def relative_key_path
    "config/kryptos.key"
  end

  def cleartext_path
    "#{Rails.root}/#{relative_cleartext_path}"
  end

  def encrypted_path
    "#{cleartext_path}.enc"
  end

  def key_path
    "#{Rails.root}/#{relative_key_path}"
  end

  def secret
    @secret ||= IO.read(key_path).strip
  end

  def clandestine_operations
    raise "#{relative_key_path} does not exist" unless File.exists? key_path
    check_gitignore
    if File.exists? cleartext_path
      # If the encrypted version is out of date, regenerate it
      enc_mtime = File.exists?(encrypted_path) && File.mtime(encrypted_path)
      encrypt_secrets if !enc_mtime || enc_mtime < File.mtime(cleartext_path)
    else
      decrypt_secrets
    end
  end

  def check_gitignore
    return unless Rails.env.development?
    ignores = IO.read(gitignore_path)
    raise "gitignore must ignore #{relative_cleartext_path}" unless ignores =~ /^#{relative_cleartext_path}$/
    raise "gitignore must ignore #{relative_key_path}" unless ignores =~ /^#{relative_key_path}$/
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
