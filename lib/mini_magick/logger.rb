require "benchmark"

module MiniMagick
  class Logger

    attr_accessor :format

    def initialize(io)
      @io     = io
      @format = "[%<duration>.2fs] %<command>s"
    end

    def debug(command, &action)
      benchmark(action) do |duration|
        output(duration: duration, command: command) if MiniMagick.debug
      end
    end

    private

    def output(data)
      printf @io, "#{format}\n", data
    end

    def benchmark(action)
      return_value = nil
      duration = Benchmark.realtime { return_value = action.call }
      yield duration
      return_value
    end

  end
end
