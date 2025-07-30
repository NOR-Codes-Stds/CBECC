# *Modelkit*

*Modelkit* is a parametric template framework that automates the generation, management, and execution of *EnergyPlus* models (or any text-based input file)—-making it possible to efficiently perform parametric studies. *Modelkit* is designed to be a replacement for older text processing programs such as *EPMacro*.

We use *Modelkit* for all of our in-house modeling projects. We also train and support our clients on how to work with *Modelkit*. Although not yet released publicly, *Modelkit* is free, open-source software.

The templates in *Modelkit* are plain text files that consist of standard *EnergyPlus* input file (IDF) syntax "marked up" or parametrized with dynamic content in the [Ruby scripting language](https://www.ruby-lang.org/). Because the templates are mostly made up of IDF objects, the templates can be readily modified and extended by energy modelers and other non-programmers. Ruby is a full-featured, modern programming language that allows nearly unlimited flexibility for configuring templates. Yet it has a simple, easy-to-learn syntax that makes everyday template tasks as straightforward as programming an *Excel* macro. Templates can be parametrized with any number of inputs.

## Installation

There are two ways to install *Modelkit*. For most users the recommended--and easiest--way is to install the *Modelkit Catalyst* package using the installer programs for Windows or Mac. The other way to install *Modelkit* is as a [Ruby gem](https://en.wikipedia.org/wiki/RubyGems).

### *Modelkit Catalyst*

*Modelkit Catalyst* bundles together the *Modelkit* command-line tools along with the Net Zero template library and an example project. It also includes its own Ruby interpreter so **you do not need to have Ruby installed to use *Modelkit***. You can download *Modelkit Catalyst* here:

[Modelkit Catalyst installer for Windows](http://downloads.bigladdersoftware.com/?ref=modelkit-catalyst-latest-win)  
[Modelkit Catalyst installer for Mac](http://downloads.bigladdersoftware.com/?ref=modelkit-catalyst-latest-mac)

You should be able to type `modelkit` at the command-line prompt to verify that it installed correctly. (NOTE: The Windows installer adds *Modelkit Catalyst* to your PATH environment variable.)

### Ruby Gem

Ruby gems are a standard format for distributing Ruby programs and libraries. Installing *Modelkit* as a gem is mainly suggested for software developers and Ruby programmers. You must have Ruby 2.0 installed on your system before proceeding. The steps for installation are below:

- Download the *Modelkit* gem from [here](http://downloads.bigladdersoftware.com/?ref=modelkit-gem-latest)
- Install the gem at the command line by typing: `gem install modelkit-x.y.z.gem`
- Download the *Modelkit for EnergyPlus* gem from [here](http://downloads.bigladdersoftware.com/?ref=modelkit-energyplus-gem-latest)
- Install the gem at the command line by typing: `gem install modelkit-energyplus-x.y.z.gem`

*NOTE: Rubygems might take a couple minutes to sort out dependencies before installation begins.*

Make sure you install the local copy of the gem by running `gem install` from the same working directory as the gem. If you just type `gem install` from any location, Rubygems will complain that it could not find a valid gem. Do not use the `--local` option with `gem install` because it prevents Rubygems from downloading the other required gem dependencies.

These steps should work the same for Windows, Mac, or Linux. On Mac and Linux you may need to use `sudo gem install`.

You should be able to type `modelkit` at the command-line prompt to verify that it installed correctly as a gem.

## Usage

Type `modelkit help` at the command prompt to get a list of allowable commands.

Type `modelkit help <command>` at the command prompt to get a list of allowable switches and flags for a given command. For example: `modelkit help template-compose`

See the file **doc/documentation.txt** for more information.

## Copyright

Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.

## License

See the file **license.txt**.
