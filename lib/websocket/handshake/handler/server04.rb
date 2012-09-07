require 'digest/sha1'
require 'base64'

module WebSocket
  module Handshake
    module Handler
      module Server04

        include Server

        def valid?
          super && (@headers['sec-websocket-key'] ? true : (set_error(:invalid_handshake_authentication) and false))
        end

        private

        def header_line
          "HTTP/1.1 101 Switching Protocols"
        end

        def handshake_keys
          [
            ["Upgrade", "websocket"],
            ["Connection", "Upgrade"],
            ["Sec-WebSocket-Accept", signature]
          ]
        end

        def signature
          return unless key = @headers['sec-websocket-key']
          string_to_sign = "#{key}258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
          Base64.encode64(Digest::SHA1.digest(string_to_sign)).chomp
        end

      end
    end
  end
end
