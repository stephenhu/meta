module Meta

  class Webtools
    include Capybara::DSL

    def initialize

      Capybara.configure do |config|
        config.run_server       = false
        config.default_driver
        config.current_driver   = :webkit
        config.app              = "meta page"
        config.app_host         = ""
      end

    end

    def to_thumbnail(url)

      visit url

      page.driver.resize_window( 1024, 768 )

      hash = Digest::MD5.hexdigest(url)

      filename = hash[0..8] + PNGEXT

      unless File.exists?(filename)

        page.save_screenshot( filename, width: 1024, height: 768 )

        return true

      end

      return false

    end

  end

end

