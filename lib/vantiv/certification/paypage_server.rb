require 'erb'
require 'webrick'
require 'vantiv'

module Vantiv
  module Certification
    class PaypageServer
      def initialize(threaded: true)
        @threaded = threaded
        @template = "#{Vantiv.root}/lib/vantiv/certification/views/index.html.erb"
        @static_file_dir = "#{Vantiv.root}/tmp/e-protect"
      end

      def start
        if threaded
          @server_thread = Thread.new do
            compile_template
            server = WEBrick::HTTPServer.new :Port => port, :DocumentRoot => document_root
            Thread.current.thread_variable_set(:server, server)
            trap('INT') { server.shutdown }
            server.start
          end
        else
          start_server
        end
      end

      def root_path
        "http://localhost:#{port}"
      end

      def stop
        if threaded
          server_thread.thread_variable_get(:server).shutdown
          Thread.kill(server_thread)
        else
          stop_server
        end
      end

      private

      attr_accessor :server, :server_thread, :threaded

      def document_root
        File.expand_path "#{static_file_dir}"
      end

      def port
        8000
      end

      def start_server
        compile_template
        server = WEBrick::HTTPServer.new :Port => port, :DocumentRoot => document_root
        trap('INT') { server.shutdown }
        server.start
      end

      def stop_server
        server.shutdown
      end

      def static_file_dir
        unless File.directory?(@static_file_dir)
          FileUtils.mkdir_p(@static_file_dir)
        end
        @static_file_dir
      end

      def compile_template
        template = File.open(@template)
        File.open("#{static_file_dir}/index.html", "w") do |f|
          renderer = ERB.new(template.read)
          f << renderer.result()
        end
      end
    end
  end
end

