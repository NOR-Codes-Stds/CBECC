# Modelkit for EnergyPlus

## API

Sample Ruby code is shown below that demonstrates using the API to read, modify,
and write *EnergyPlus* IDF files. NOTE: The `OpenStudio` module namespace is copied
from *Legacy OpenStudio* (now called *Euclid*).

```ruby

require("modelkit/energyplus")

# Read an IDD and get the version number.
version = OpenStudio::DataDictionary.version("/Applications/EnergyPlus-8-9-0/Energy+.idd")
puts version  # => 8.9.0

# Parse the specified IDD.
idd = OpenStudio::DataDictionary.open("/Applications/EnergyPlus-8-9-0/Energy+.idd")

# Read an object "class" definition from the IDD.
class_def = idd.get_class_def("BuildingSurface:Detailed")
puts class_def.name  # => BuildingSurface:Detailed
puts class_def.description  # => "Allows for detailed entry of building heat transfer surfaces..."
puts class_def.min_fields  # => 19

field_defs = class_def.field_definitions
field_defs.shift  # Remove first item; it's blank
field_defs.each do |f|
  puts "field=#{f.name}, units_si=#{f.units_si}, required=#{f.required}, default=#{f.default_value}"
end

# Parse the specified IDF.
idf = OpenStudio::InputFile.open(idd, "test/test.idf")
puts idf.objects.length  # => number of objects in the file

# Find objects in the IDF by class name.
surfaces = idf.find_objects_by_class_name("BuildingSurface:Detailed")
puts surfaces.length  # => number of BuildingSurface:Detailed objects in the file
surfaces.each do |surface|
  puts "name=#{surface.fields[1]}, type=#{surface.fields[2]}, zone=#{surface.fields[4]}"  # etc.
end

# Find objects in the IDF filtered by constraints.
filtered_surfaces = surfaces.find_all { |surface| surface.fields[2] == "Roof" and surface.fields[7] == "SunExposed" }
filtered_surfaces.each do |surface|
  puts "name=#{surface.fields[1]}, type=#{surface.fields[2]}, zone=#{surface.fields[4]}"  # etc.
end

# Find a specific object by class name and object name.
my_surface = idf.find_object_by_class_and_name("BuildingSurface:Detailed", "989F62")
puts my_surface.fields.inspect if (my_surface)  # => ["BuildingSurface:Detailed", "989F62", "Wall", "Wall", "Floor 1 Office Space" ... etc.

# Delete a specific object.
idf.delete_object(my_surface)

# Create a new object.
object = OpenStudio::InputObject.new("GlobalGeometryRules", ["GlobalGeometryRules", "UpperLeftCorner", "Counterclockwise", "Relative", "Relative"])
idf.add_object(object)

# Modify an existing object.
object.fields[4] = "Absolute"
object.fields[5] = "Absolute"

# Save the modified IDF to a new location.
idf.write("test/test-modified.idf")

```

## Copyright

Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.

## Adding New Sizing Files

The rakefile, `rakefile.rb`, contains tasks for adding/updating the
`resources/sizing-map/*.csv` files from an **EnergyPlus** `IDD` file. `IDD` files
are added to the `resources/idds` file with names such as `9-0.idd` (renamed
from `EnergyPlusV9-0-0/Energy+.idd`). These files are processed and output as
`resources/sizing-map/9-0.csv` (for example). The basic algorithm is:

1. Scrape the IDD looking for objects with autosizable fields
    - store the object name, field index, and field name
2. Write the above data to a csv file
3. Hand edit and update as needed

Calling the creation of new sizing files (assuming the `Modelkit` packaging
exists as a sibling directory to `modelkit-energyplus`):

```
rake -I../modelkit/lib -Ilib sizing_maps
```

## License

See the file **license.txt**.
