module Mondido
  class Credentials
    @@merchant_id = nil
    @@secret = nil
    @@password = nil

    def self.merchant_id
      setup if @@merchant_id.nil?
      @@merchant_id
    end

    def self.secret
      setup if @@secret.nil?
      @@secret
    end

    def self.password
      setup if @@password.nil?
      @@password
    end

    private

    def self.setup
      config_file = File.join(Rails.root, 'config', 'mondido.yml')
      if File.exist?(config_file)
        yaml = YAML.load(File.read(config_file))
        @@merchant_id = yaml['merchant_id'] 
        @@secret = yaml['secret'] 
        @@password = yaml['password'] 
      else
        raise Mondido::Exceptions::MissingFile.new 'Could not locate config/mondido.yml'
      end
    end

  end
end
