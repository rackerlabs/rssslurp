require 'log4r'

# Convenience module to grant access to the One True Logger.
module Loggable

  def logger
    @logger ||= Log4r::Logger['default']
  end

end
