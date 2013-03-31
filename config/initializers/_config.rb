# load custom config vars
APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]