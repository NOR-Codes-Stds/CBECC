# Patches and overrides for Ripl gem.

class Ripl::Shell

  module API

    # Override the main event loop to fix some quirks.
    def loop_once
      @error_raised = nil

      # Hit 'eval' once to initialize the history otherwise the first entry is not included in the history stack.
      eval("_ = Ripl.shell.result", @binding)  # From 'eval_input' method

      @input = get_input
      if EXIT_WORDS.include?(@input)
        # A nil value indicates Ctrl+D has been entered; a side effect is that there is no character or newline printed.
        puts "^D" if (@input.nil?)
        throw(:ripl_exit)
      end
      eval_input(@input)
      print_result(@result)
    rescue Interrupt
      handle_interrupt
    end
  end

end
