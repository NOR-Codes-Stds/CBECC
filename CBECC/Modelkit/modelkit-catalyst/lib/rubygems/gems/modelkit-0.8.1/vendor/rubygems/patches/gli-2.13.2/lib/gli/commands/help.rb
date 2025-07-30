# Patches and overrides for GLI gem.

module GLI
  module Commands

    class Help

      # Override the Help command to customize.
      def initialize(app,output=$stdout,error=$stderr)
        super(:names => :help,
              :description => 'Show a list of commands or help for one command',
              :arguments_name => 'command',
              :long_desc => 'Gets help for the application or its commands. Can also list the commands in a way helpful to creating a bash-style completion function',
              :arguments => [Argument.new(:command_name, [:multiple, :optional])])
        @app = app
        @parent = app
        @sorter = SORTERS[@app.help_sort_type]
        @text_wrapping_class = WRAPPERS[@app.help_text_wrap_type]
        @synopsis_formatter_class = SYNOPSIS_FORMATTERS[@app.synopsis_format_type]

        desc 'List commands one per line, to assist with shell completion'
        switch :c

        action do |global_options,options,arguments|
          if global_options[:version] && !global_options[:help]
            puts "#{@app.exe_name} #{@app.version_string}"
          else
            show_help(global_options,options,arguments,output,error)
          end
        end
      end

    end

  end
end
