require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppName
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # 学習段階では基本設定のみ
    config.autoload_lib(ignore: %w(assets tasks))
    
    # 不要なコメントを削除してシンプルに
  end
end
