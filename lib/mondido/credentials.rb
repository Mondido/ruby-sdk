module Mondido
  class Credentials
    unless Rails.root.nil?
      config_file = File.join(Rails.root, 'config', 'mondido.yml')
      if File.exist?(config_file)
        yaml = YAML.load(File.read(config_file))
      else
        raise 'Could not find app/mondido.yml'
      end

      MERCHANT_ID ||= yaml['merchant_id'] or raise 'Mondido merchant ID not set in config/mondido.yml'
      SECRET ||= yaml['secret'] or raise 'Mondido secret not set in config/mondido.yml'
      PASSWORD ||= yaml['password'] or raise 'Mondido password not set in config/mondido.yml'
    end
  end
end
