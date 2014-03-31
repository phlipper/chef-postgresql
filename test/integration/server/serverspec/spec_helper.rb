require "serverspec"
require "pathname"

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
  end
end

module SpecInfra
  module Command
    class Debian < Linux
      def check_running(service)
        "pgrep #{escape(service)} | grep -E '[0-9]+'"
      end
    end
  end
end
