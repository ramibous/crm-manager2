require 'find'

# Directory to search
directory = '/Users/ramiboussarsar/code/crm-manager/app/assets/stylesheets/'

# Regex pattern to match class definitions
pattern = /\.([a-zA-Z0-9_-]+)\s*\{/

# Hash to store class definitions and their file locations
class_definitions = Hash.new { |hash, key| hash[key] = [] }

# Walk through the directory and search for class definitions
Find.find(directory) do |path|
  next unless path =~ /\.scss$/
  File.open(path, 'r') do |file|
    file.each_line do |line|
      if match = line.match(pattern)
        class_definitions[match[1]] << path
      end
    end
  end
end

# Print duplicated class definitions
class_definitions.each do |class_name, locations|
  if locations.size > 1
    puts "Class .#{class_name} found in:"
    locations.each { |location| puts "  - #{location}" }
  end
end
