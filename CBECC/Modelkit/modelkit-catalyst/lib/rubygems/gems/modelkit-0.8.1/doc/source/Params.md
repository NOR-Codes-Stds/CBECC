% 1
% Big Ladder Software
% 2013.10.01

# Params 

## Contents

### Overview 

- Templates 
- Case files 
- Data flow 
- Possibilities 

### Details 
- Running Params Compose 
- Running Other Params Commands 
- Template Files 


\newpage

## Overview

In its most basic concept, Params is a system of templates.  By using one file for entering parameters and other text files as templates or building blocks, nothing is hidden, masked or unavailable to the user.   

### Templates

Tasks can be repetitive or consistent from project-to-project.  Templates automate tasks. Users can choose ready-made templates or create their own templates once and use them over and over.  

The work involved with the Params template system is in pulling these templates together and referencing the parameters that get inserted.  

### Parameters

A parameter is a special kind of variable. In mathematics, 
it is a constant or variable term in a function that determines the specific form of the function but not its general nature, as in  

	f(x) = ax  

where `a`  determines only the slope of the line described by `f(x)`. It does not change the function `f` from being a straight line.  

In Params, the user can set up one template, or the "form of the function" and use it again and again with many parameter values.  

### Data Flow

Params is a text-based system.  It takes parameter values, replaces their assigned parameter variable and outputs the compilation to a text file. The best way to use Params is to keep parameter values in one file, have a root file that collects these values and either manipulates them or simply passes them along to a template file.  This root file can also then call other template files for more complicated tasks.  Following is an illustration of how this data flows through the example files. 

### Posibilities

In graphical interface software, data entries are made in entry fields which are used by the program during calculation.  In a text-based system such as Params, data entry is made directly into a template file or remotely in a text file. The template files contain parameter variables which save the place for data entry.Params composes all of this information and passes it into one output file.  

Their are a few advantages to this. The first is data entry isolation.  Each separate data file can contain all and only the information that is being entered.  This gives the user complete control over the parameters without having to search through a multitude of dialogs, drop down menus, and entry fields to diagnose or debug file.  

Another is that once a template is perfected, it can be saved and protected in a isolated file.   

By using separate files for data entry and text templates, multiple users can work on one project at a time.  For example, one user might be in charge of collecting and inputting data into one data file and another for creating templates to manipulate that data.   

Params affords the user complete customization and automation without any loss or limitation in capability.  An initial fee is charged by Big Ladder Software, the creator of Params, for new templates not already available, but once they are created they are freely available to all future users.  Proprietary templates with licenses can be created for an additional fee and royalties. **(#Check with Peter, I made this up.)** 

## Details

### Running Params *Compose* Command  

**# Ask Peter if a _compose.bat file could be included with Params in the bin folder. I don't see it in there. **  

To activate Params from your file browser (i.e. Windows Explorer, Finder), make a copy of the **\_compose.bat** file (found in the **bin** directory), and place it in the folder containing the template file.  Drag and drop the template file onto the **\_compose.bat** file.  Params will write out an output file with all default parameters filled in.  The default name for this output file is *filename*.out, where *filename* is the name of the template file.  Try this with the example template file **simple.idf** in the examples folder.

There are four parameters in the example template **simple.idf**. They are `run_control`, `building_name`, `orientation`, and `lighting_density`.  The example is taken from a program that evaluates building energy use.  

####Initialize

A list of all parameters used within a template should be a included at the top of the file like this with "<%#INITIALIZE" exactly as shown:

	<%#INITIALIZE

	parameter "variable_name1", :default=>6
	parameter "variable_name2", :default=>"Coolest variable"
	parameter "variable_name3",
	parameter "variable_name4"

	%>

This example illustrates two other important syntaxes, **:default** and **=>**. The **:default** indicates that  the preceding parameter is to be assigned with a default value. The **=>** assigns the  default value. Thus, the default value for `variable_name1` is `6`. 

The **:** and **=>** code combination can also be used to assign non-default values. Instead of the word "default" following the colon, the parameter name is used. 

	<% :varialbe_name1=>242 %>

Since `variable_name1` has a default value of `6`, if `variable_name1` is encountered in the text file before the statement above its value will be `6`. Once the statement above is reached its value will be reassigned to `242` and remain so until an new assignment statement is reached.
 
In Params, not all variables need a default value, but it can be helpful in avoiding fatal errors and for debugging.  This is because all parameters must be given a value somewhere in a template, or a value must be passed through to a template before the Params **compose** command will execute.

Note that the last parameter in the initialization list must not be followed by comma and must have an end bracket, **%>**. This is how the program knows it is at the end of the list.

### Template Files

In the **Run Params Compose Command** section an example template file, **simple.idf**, from the examples folder was used.  Templates are plain text files that are marked up with embedded Ruby to insert parameter values, insert sub-templates, and to generate and manipulate output.

To embed a Ruby command, bracket it with **<% %>**.  For example, to assign a parameter "NumOfBlindMice" equal to 3, open your template file in a text editor and enter: 

	<% :NumOfBlindMice=>3 %>

### Running Params *Compose* Command from the Command Line

Params can also be run directly from the Windows command line.   Enter "**cmd.exe**" in the search box of the Windows Start button to open the command line.  To run, type "**Params compose** " and then the path and file name of the template file. Hit **enter**.  By using Params through the command line, several compose options can be implemented.  If you place the following "flags" between **compose** and the filename on the command line, you will see the following results. 

    -a                   - Return absolute paths
    -d, --dirs=arg       - Search directory paths
    -f, --files=arg      - Apply parameter files
    -o, --output=arg     - Output path (default: filename.out)
    -p, --parameters=arg - Apply parameter values
    -q                   - Return double-quoted paths

The **-o** flag can be used to change the output name.  For example, 

	params compose -o output.out *<path>*simple.idf

will produce a file "output.out" instead of "simple.out."

The "simple.idf" example file uses default values in the initialization header to fill in the parameters.  Instead of setting parameters to a default within a template file, you can call the parameter values from a separate parameter file using the **-f** flag.  Try this with the example  files using: 

	params compose -o output.idf -f parameters.txt simple.idf

**# Enter here what the other options mean or do and why they are useful**

####More Embedded Ruby Commands

These additional embedded Ruby commands will be discussed below. 

![](./media/rubytable.png)

####Comment, # ####

The **#** can be used to create a user comment such as "Below are the names of the really important variables."  This is also very useful for the purpose of debugging a file to temporarily disable a function.  Place a **#** in front of the function. Ruby ignores all text that follows this symbol until the next return or a bracket closing is found.  The only exception to this is in the initialization code, `<%#INITIALIZE ... %>` 

####Strings, ', "

Strings are variable values that include characters in addition to numbers. Ruby and Params accepts either a single quote **'** or a double quote **"** to denote a string. This can be used to call out a file name, a variable, or text.  If the string itself *contains* a single quote, bracket it in double quotes and if it contains a double quote, bracket it in single quotes.

####For

The **For** command is used here in an example: 

	<% for tree_falling in forest %>
		print "I hear you"
	<% end %>

This is also an example of the "**print**" command. In this example if there are 3,442 trees in the array "forest", Ruby will print "I hear you" 3,442 times. The tree variable does not necessarily need to be defined before this command is issued, but the forest array does. See the section **Arrays** below.

####If, Elsif, Else
This set of commands always starts with the **if** command and may or may not include **elsif** or **else**. It must always have and **end** command. To demonstrate: 

	<% if i_eat == apples %>
	print "Yum"
	<% elsif i_eat == lima_beans %>
	print "Yuck"
	<% elsif i_eat == oranges %>
	print "These aren't apples"
	<% else %>
	print "Compared to lima beans, these apples are good." 
	<% end %>

\begin{mdframed}[hidealllines=true,backgroundcolor=gray!20,innerleftmargin=3pt,innerrightmargin=3pt,leftmargin=-3pt,rightmargin=-3pt]

The double equal sign denotes that a comparison is being made (as apposed to the singe equal sign which sets one thing equal to another). 

Note there is only one 'e' in elsif.

\end{mdframed}

Both the **elsif** statement about lima beans and the **elsif** statement about oranges (and their associated **print** commands) can be excluded if desired. Though not technically necessary, it is a good idea to include an **else** command as an inclusive so the program knows what to do if the if comparison is false.

####End

All **for** and **if** statements must be closed by an **<% end %>**.

####Arrays
To tell Params that a variable is to represent a list of values, also know as an array, use empty brackets: **[ ]**. Then define the array and separate each item in the list with a comma. Remember to use quotes if the items are strings.

	animals = []
	animals = ['mountain','desert','ocean']


Arrays can also contain arrays.  This is a nested array:

	animals = [
		['mountain','mountain lion','elk','big horn sheep'],
		['desert','road runner','camel','lizard'],
		['ocean','shark','eel','octopus']
	]

Think of these as rows and columns where the first list is the first row and the second list is the second row . The first item in each list would make up the first column and the second item in each list would make up the second column, etc.

An **if** statement nested into a **for** statement is good for assigning variable to the values in a nested array and then executing code unique to each list entry. 

	<% for habitat in animals %>	
  	 <%
    	animal_habitat = habitat[0]
    	animal1 = habitat[1]
    	animal2 = habitat[2]
    	animal3 = habitat[3]
  	 %>
		<% if (animal_habitat == 'mountain') %>
			print "These animals like high altitude:"
		<% elsif (animal_habitat == 'desert') %>
			print "These animals like dry, hot areas:"
		<% elsif (animal_habitat == 'ocean') %>
			print "These animals like to be under water:"
		<% else %>
			print "I don't know what these animals like:"
		<% end %> 

		<% print animal1, animal2, animal3 %>
	 
	<% end %>

In this example, the **for** statement is simultaneously calling out `habitat` as an array and assigning variable names to it. **(Confirm this with Peter)** The first set of Ruby instructions, 

	 <%
    	animal_habitat = habitat[0]
    	animal1 = habitat[1]
    	animal2 = habitat[2]
    	animal3 = habitat[3]
  	 %>

assigns a variable name to each value (list item) in the array's columns and the **for** statement steps it through each row.  Ruby uses [0] to denote the first item in an array, then [1] for the second item and so on.

The variables `animal1, animal2, animal3` acquire new values three times as they move through the **for** statement because the array `animals` contains three list items.

\begin{mdframed}[hidealllines=true,backgroundcolor=gray!20,innerleftmargin=3pt,innerrightmargin=3pt,leftmargin=-3pt,rightmargin=-3pt]

Notice how the indentation makes the code easier to read and process. This is not necessary for the program, but it helps out a lot during programming and debugging. 

\end{mdframed}


####Insert

This is Params' way of "nesting" a template. First, the **<%= insert %>** command calls out the template that is to be inserted. Then it passes parameters from the active template into the called template and inserts the parameter value into the final output file. For example, 

	<%= insert 'car.imf',  	
	:car_color=>red,
	:car_type=>sport,
	:car_top=>convertible
	<%
passes the variables and variable values `car_color (red)`, `car_type (sport)`, and `car_top (convertible)` from the current template into the `car.imf` template.  Thus, when `car_color` gets passed into `car.imf` its value is "`red`."

Both the template which contains this embeded Ruby and the template `car.imf` must have `car_color`, `car_type`, and `car_top` initialized as parameters. See the section **Initialize**. 

\begin{mdframed}[hidealllines=true,backgroundcolor=gray!20,innerleftmargin=3pt,innerrightmargin=3pt,leftmargin=-3pt,rightmargin=-3pt]

Note there is no comma after the last variable is listed and that the name of the called template is in quotes.

\end{mdframed}

### Running Other Params Commands

A list of all available Params commands can be found from the command line. Enter "params" or "params help." 

Commands available for this version are: 

**#Ask Peter what commands are available**

    batch     - Generates a list of files
    compose   - Compose a template with parameter values and files
    expand    - Expand parameter directories to a run directory 
				structure
    help      - show list of commands or help for one command
    sweep     - Sweep parameters over a range to generate parameter 
				files

The **compose** command is explained in the previous section. The **batch** command ...  
**#Enter here what these commands mean or do and why they are useful**



\newpage

###Glossary

*array* - a parameter that contains a list 

*assign* - setting a value to a variable

*called template* - a template that is called out from a parent template using the **insert** command 

*comment* - text in a file that is not read by the program  

*embedded Ruby* - a common programming language. For more information and basics, see [http://en.wikipedia.org/wiki/ERuby](http://en.wikipedia.org/wiki/ERuby)  

*flag* - usually one or a few character that are placed after a dash after a command on the command line to alter the performance of the command

*nested array* - a list of lists, these can be thought of as rows and columns where the first list is the first row (or column) and the second list is the second row (or column). The first item in each list would make up the first column (or row) and the second item in each list would make up the second column (or row), etc.

*parameter* - variable, a placeholder for information that can changed based on code that assigns values
  
*parent template* - a template that calls out another template using the **insert** command  

*string* - a variable value that contains more than numbers

*variable value* - the number or string that is currently assigned to a parameter. If a value has not been assigned the default value is used. If a default value is also not assigned, the compose command will fail. 
 
\newpage

###Index  

