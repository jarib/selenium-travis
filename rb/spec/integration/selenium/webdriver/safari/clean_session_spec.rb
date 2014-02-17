module Selenium
  module WebDriver
    module Safari

      describe 'with clean session', focus: false do
        before { GlobalTestEnv.quit_driver }

        def create_clean_driver
          @driver = WebDriver.for :safari, :clean_session => true
          @driver.get url_for('alerts.html')

          @driver
        end

        after { @driver.quit if @driver }

        it 'should clear cookies when starting with a clean session' do
          driver = create_clean_driver
          driver.manage.add_cookie(name: 'foo', value: 'bar')

          cookie = driver.manage.all_cookies.find { |e| e.values_at(:name, :value) == %w[foo bar] }
          cookie.should_not be_nil

          driver.quit
          driver = create_clean_driver

          cookie = driver.manage.all_cookies.to_a.find { |e| e.values_at(:name, :value) == %w[foo bar] }
          cookie.should be_nil
        end
      end

    end # Safari
  end # WebDriver
end # Selenium

