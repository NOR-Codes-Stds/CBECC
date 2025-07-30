# Modelkit-CBECC integration script
#
# To run, use the command line call:
#   CALL "CBECC-Com 2019\Modelkit\modelkit-catalyst\bin\modelkit.bat" ruby "CBECC-Com 2019\Modelkit\hybrid-hvac.rb" "<path-to-processing-dir\project-file-base-name>"
#
# The script expects to find the following files in the processing directory:
#   <project-file-base-name> - HybridHVAC-initial.idf  =>  initial IDF written by CBECC
#   <project-file-base-name> - HybridHVAC.csv          =>  table of parameter values by zone
#
# Example:
#   Project file base name:  020012-OffSml-CECStd - ap
#   Initial IDF:             020012-OffSml-CECStd - ap - HybridHVAC-initial.idf
#   Parameters CSV:          020012-OffSml-CECStd - ap - HybridHVAC.csv
#
#   CALL "CBECC-Com 2019\Modelkit\modelkit-catalyst\bin\modelkit.bat" ruby "CBECC-Com 2019\Modelkit\hybrid-hvac.rb" "Documents\CBECC-Com 2019\StandardModelTests2019\020012-OffSml-CECStd - ap"
#
# To run without showing a console window, set the environment variable CONSOLE to "off"
# before calling the Modelkit script. Environment variable and call can be evaluated in
# the same line as follows:
#
#   SET CONSOLE=off & CALL "CBECC-Com 2019\Modelkit\modelkit-catalyst\bin\modelkit.bat" ruby "CBECC-Com 2019\Modelkit\hybrid-hvac.rb" "Documents\CBECC-Com 2019\StandardModelTests2019\020012-OffSml-CECStd - ap"

if (ENV['CONSOLE'].to_s.strip.downcase == "off")
  # When no console window, redirect stdout and stderr to a log file for debugging.
  $stdout = $stderr = File.open("#{ARGV[0]} - HybridHVAC.log", "w")
end

start_time = Time.now
puts "Started processing with Modelkit"
puts "  Arguments = #{ARGV.inspect}"

if (not ARGV[0])
  raise("base path not specified")
elsif (not ARGV[1])
  raise("EPlus path not specified (second argument)")
end

base_path = File.expand_path(ARGV[0])
puts "  Base Path = \"#{base_path}\""

# eplus_path = File.expand_path("C:/CBECC/SVN-MFamRestruct-wHybridClg/sim-EPlus/current")
eplus_path = File.expand_path(ARGV[1])
puts "  EPlus Path = \"#{eplus_path}\""

proc_dir = File.dirname(base_path)
out_idf_path ="#{base_path}.idf"
pre_idf_path = "#{base_path} - HybridHVAC-initial.idf"
csv_path = "#{base_path} - HybridHVAC.csv"

if (not File.exist?(pre_idf_path))
  raise("pre idf file not found \"#{pre_idf_path}\"")
end

if (not File.exist?(csv_path))
  raise("csv data file not found \"#{csv_path}\"")
end


ROOT_DIR = __dir__
TEMPLATES_DIR = "#{ROOT_DIR}/templates"

require("modelkit/parametrics")
require("modelkit/energyplus")

# idd = OpenStudio::DataDictionary.open("#{ROOT_DIR}/../../sim-EPlus/current/Energy+.idd")
idd = OpenStudio::DataDictionary.open("#{eplus_path}/Energy+.idd")
pre_idf = OpenStudio::InputFile.open(idd, pre_idf_path)

base_temp_path = "#{base_path} - HybridHVAC-temp"
temp_pxv_path = "#{base_temp_path}.pxv"
temp_idf_path = "#{base_temp_path}.idf"

append_idf_text = ""

require("csv")

CSV.foreach(csv_path, :headers => true, :header_converters => :downcase, :converters => :numeric) do |row|
  zone_name = row["zonename"]
  system_name = row["systemname"]
  object_name = "#{zone_name} #{system_name}"

  # ---ZoneHVAC:EquipmentConnections---
  connections = pre_idf.find_object_by_class_and_name("ZoneHVAC:EquipmentConnections", zone_name)
  if (connections)
    puts "Processing zone \"#{zone_name}\""
  else
    puts "Warning: skipping zone \"#{zone_name}\" - ZoneHVAC:EquipmentConnections not found"
    next
  end

  equipment_list = connections.fields[2]  # Field: Zone Conditioning Equipment List Name
  inlet_node_list = connections.fields[3]  # Field: Zone Air Inlet Node or NodeList Name
  return_node_list = connections.fields[6]  # Field: Zone Return Air Node or NodeList Name

  # Zone equipment without air system connections will not have a return air node list.
  # Add and connect a new NodeList object as needed.
  if (not return_node_list)
    return_node_list_name = "#{zone_name} Return Node List"
    return_node_list = pre_idf.new_object("NodeList", ["NodeList", return_node_list_name])
    connections.fields[6] = return_node_list
  end

  # ---ZoneHVAC:EquipmentList---
  # Insert hybrid HVAC as first in list *and* first cooling and heating sequence.
  # (Questionable whether an exhaust fan should come first--CBECC does not put fan first.)
  new_fields = ["ZoneHVAC:HybridUnitaryHVAC", object_name, 1, 1, nil, nil]
  equipment_list.fields.insert(3, *new_fields)

  # Increment cooling and heating sequence values for all equipment AFTER hybrid HVAC.
  equipment_count = (equipment_list.fields.length - 3) / 6
  (2..equipment_count).each do |count|
    index = 6 * count - 1
    # Field: Zone Equipment Cooling Sequence
    equipment_list.fields[index] = equipment_list.fields[index].to_i + 1
    # Field: Zone Equipment Heating or No-Load Sequence
    equipment_list.fields[index + 1] = equipment_list.fields[index + 1].to_i + 1
  end

  equipment_list.context = nil  # Clear the context string so that entire object is reformatted

  # ---NodeList---
  # Insert hybrid HVAC nodes in NodeList connections.
  # NOTE: inlet_node_list and return_node_list should be InputObjects at this point, but instead
  #   they are still the string names of the objects. The IDF processing is not mapping the
  #   names to object references correctly for NodeList fields. Therefore the InputObjects have
  #   to be found first.
  node_list = pre_idf.find_object_by_class_and_name("NodeList", inlet_node_list.to_s)
  if (not node_list)
    puts "Error: Skipping \"#{inlet_node_list}\" - NodeList not found"
  else
    node_list.fields << "#{zone_name} #{system_name} Supply Air Node"
  end

  node_list = pre_idf.find_object_by_class_and_name("NodeList", return_node_list.to_s)
  if (not node_list)
    puts "Error: Skipping \"#{return_node_list}\" - NodeList not found"
  else
    node_list.fields << "#{zone_name} #{system_name} Return Air Node"
  end

  # Generate PXV parameter values file.
  pxv_text = ""; row.each do |header, value|
    if (not header)
      puts "Warning: Skipping column with missing header label"
    elsif (header.strip.empty?)
      puts "Warning: Skipping column with blank header label"
    else
      pxv_text << ":#{header.strip} => #{value.inspect},\n"
    end
  end
  File.write(temp_pxv_path, pxv_text)

  # Compose hybrid HVAC template with given parameter values and write out to a temporary file.
  Modelkit::Parametrics.template_compose("#{TEMPLATES_DIR}/hybrid-hvac.pxt",
    {:files => [temp_pxv_path], :output => temp_idf_path, :annotate => true, :esc_line => "! " })

  # Unfortunately compose only writes to a file, not a string. Must read again to append.
  append_idf_text << File.read(temp_idf_path)
end

pre_idf.write(out_idf_path)  # Cannot just write IDF to a string--must be a file

out_file = File.open(out_idf_path, "a")  # Reopen as text-only in append mode
out_file.write("\n")  # Ensure a blank line before appending new content
out_file.write(append_idf_text)
out_file.close

# Delete temporary files.
FileUtils.rm(Dir["{#{base_temp_path}*,#{proc_dir}/@*.idf.rb}"])

puts "Completed processing"
puts "Elapsed time = #{Time.now - start_time} sec"
