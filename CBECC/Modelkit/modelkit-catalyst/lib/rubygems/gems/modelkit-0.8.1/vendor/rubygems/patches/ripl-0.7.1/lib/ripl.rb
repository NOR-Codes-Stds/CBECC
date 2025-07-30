# Patches and overrides for Ripl gem.

module Ripl

  # Add setter to allow assignment of shell object reference so that "_ = Ripl.shell.result" works.
  def self.shell=(object)
    @shell = object
  end

end
