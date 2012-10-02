#!/usr/bin/env ruby

require "rubygems"
require "plist"

# run through all retina images, check if they are correct (even pixel width and height) and create non retina versions of the images if they don't exist
# if a retina image has a newer timestamp than the non retina version the non retina version is recreated

@current_file = nil
@current_file_properties = nil

def nonretina_filename_from_file(file)
  file.gsub("@2x", "")
end

def file_properties_for_file(file)
  return @current_file_properties if @current_file == file
  
  @current_file = file
  xml = `sips --getProperty 'allxml' #{file}`
  @current_file_properties = Plist::parse_xml(xml)
  return @current_file_properties
end

def check_file_dimensions_are_even(file)
  # check if even
  file_properties = file_properties_for_file(file)
  even = (file_properties["pixelWidth"] % 2 == 0) && (file_properties["pixelHeight"] % 2 == 0)
  return even
end

def create_nonretina_image_from_file(file)
  nonretina_filename = nonretina_filename_from_file(file)
  file_properties = file_properties_for_file(file)
  new_width = file_properties["pixelWidth"] / 2
  new_height = file_properties["pixelHeight"] / 2
  # resample image
  command = "sips --resampleHeightWidth #{new_height} #{new_width} #{file} --out #{nonretina_filename} 2>&1"
  `#{command}`
end

# main

Dir.glob("*@2x.png").each do |file|
  even = check_file_dimensions_are_even(file)
  file_properties = file_properties_for_file(file)
  puts "[WARNING] #{file} has uneven dimensions: #{file_properties['pixelWidth']}x#{file_properties['pixelHeight']}px" if !even
  
  # if even, check if non-retina file exists
  nonretina_filename = nonretina_filename_from_file(file)
  if even
    if !File.exists?(nonretina_filename)
      puts "[INFO] [NEW] creating non-retina image for #{file}"
      create_nonretina_image_from_file(file)
    elsif File.exists?(nonretina_filename) && File.mtime(file) > File.mtime(nonretina_filename)
      puts "[INFO] [UPDATED] recreating non-retina image for #{file}"
      create_nonretina_image_from_file(file)
    end
  end
end