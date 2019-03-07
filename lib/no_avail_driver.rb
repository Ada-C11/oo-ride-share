class NoDriverAvailableError < StandardError
  def initialize(msg = "No driver is available")
    super
  end
end
