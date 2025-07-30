# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit")
require("modelkit/version_constraint")
require("modelkit/parametrics/group_scope")


module Modelkit
  module Parametrics

    class InterfaceScope < GroupScope

    private

      def description(text)
        @template.description = text
      end

  # NOPUB should only have one of these
      def modelkit_version(*constraints)
        if (constraints.empty?)
          raise(ArgumentError, "wrong number of arguments (0 for 1+)")
        end

        # Set the version requirement back on the Template for reference.
        #@template.modelkit_constraint = version_constraint

        #version = Gem::Version.new(Modelkit::VERSION)
        #requirement = Gem::Requirement.new(requirements)
        #if (not requirement.satisfied_by?(version))
        version_constraint = VersionConstraint.new(*constraints)
        if (not version_constraint === Modelkit::VERSION)
          puts "***MODELKIT VERSION WARNING: Modelkit version #{version_constraint} is required in template '#{@template.path}'; the current version of Modelkit is #{Modelkit::VERSION}"

          #@template_scope.annotate("***MODELKIT VERSION WARNING")
          # Annotate message to output file.
          # Also needs to echo the command: modelkit_version(constraints)
          # The @local_output created from the interface is saved in the Template and
          # printed for every occurence of the template.
        end
      end

      # Override `require` to postpone the loading of the file until eval of the overall
      # template. This accomplishes two objectives:
      # - External code dependencies are explicit and documentable.
      # - Files can be safely loaded under a mutex thread lock so that concurrency problems
      #   are eliminated.
      #def require(path)
        #@template.requires << path
      #end

  #   arg name other than requirements would be good here. the method is already 'require_gem'...
      def require_gem(gem_name, *requirements)
        begin
          # Use RubyGems to activate the correct gem which adds the gem directory to $LOAD_PATH.
          # An exception is raised if a gem cannot be found with matching name and requirements.
          gem(gem_name, requirements)
          gem_version = Gem.loaded_specs[gem_name].version

          if (require(gem_name))
            #puts "***GEM SUCCESSFULLY REQUIRED:  '#{gem_name}, #{requirements.join(', ')}' resolved to #{gem_name}-#{gem_version}"
  # Annotate message to output file.

  # NOPUB Record required gems back on the template for reference. This could be presented as part
  #  of the template documentation for users
  #  @template.gems += gem_name

          else
            #puts "***GEM ALREADY REQUIRED:  '#{gem_name}, #{requirements.join(', ')}' resolved to #{gem_name}-#{gem_version}"
  # Annotate message to output file.
          end

        rescue Exception => exception
          puts "***REQUIRE GEM ERROR: bad gem name or requirements for '#{gem_name}' in template '#{@template.path}'; gem ignored"
          puts exception
          # Annotate message to output file.
        end
      end

    end

  end
end
