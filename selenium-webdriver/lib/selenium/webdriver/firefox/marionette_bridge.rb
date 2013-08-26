module Selenium
  module WebDriver
    module Firefox
      class MarionetteClient

        def initialize(host, port)
          @host  = host
          @port  = port
          @actor = 'root'
        end

        def connect
          @socket = TCPSocket.new(@host, @port)
          @traits, @application_type = receive.values_at('traits', 'applicationType')

          send :type => 'getMarionetteID'
          @actor = receive.fetch('id')
        end

        def close
          @socket.close unless closed?
        end

        def closed?
          @socket.nil? || @socket.closed?
        end

        def send(data)
          raise "not connected" if closed?

          unless data.has_key?(:to)
            data[:to] = @actor
          end

          payload = WebDriver.json_dump(data)
          puts "writing #{payload.size} bytes: #{payload.inspect}"

          @socket.write "#{payload.bytesize}:#{payload}"
        end

        def receive
          size = ''

          until (cur = @socket.read(1)) == ':'
            raise WebDriverError::Error, "unable to read size (#{size.inspect})" if cur.nil?
            size << cur
          end

          puts "reading: #{size} bytes"
          resp = @socket.read(size.to_i)
          puts "response: #{resp.inspect}"

          WebDriver.json_load resp
        end
      end

      class MarionetteBridge < Remote::Bridge
        def initialize(opts = {})
          port    = opts[:port] || 2828
          profile = opts[:profile]
          caps    = opts[:desired_capabilities] || Remote::Capabilities.firefox

          if opts[:host]
            host = opts[:host]
          else
            host    = '127.0.0.1'

            @binary = Binary.new
            @binary.execute('--marionette')

            poller = SocketPoller.new(host, port, timeout = 60)

            unless poller.connected?
              @binary.quit
              raise Error::WebDriverError, "unable to obtain stable firefox connection in #{timeout} seconds (#{host}:#{port})"
            end
          end

          @client = MarionetteClient.new(host, Integer(port))
          @client.connect

          create_session(caps)
        end

        def quit
          super
          nil
        ensure
          @client.close
          @binary.quit if @binary
        end

        def browser
          :firefox
        end

        def driver_extensions
          []
        end

        private

        def raw_execute(cmd, opts = {}, params = nil)
          opts.merge!(params) if params

          data = {
            :type       => cmd,
            :parameters => opts,
            :session    => @session_id
          }

          @client.send data
          response = @client.receive

          if response['error']
            raise Error::WebDriverError, [response['error'], response['message']].join(': ')
          end

          Remote::Response.new(200, response)
        end
      end

    end
  end
end