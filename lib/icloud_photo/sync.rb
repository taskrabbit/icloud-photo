# encoding: utf-8

require 'fileutils'
require 'tempfile'

module ICloudPhoto
  class Sync

    SCRIPT = File.read(File.expand_path("../../applescript/sync.applescript", __FILE__), encoding: "UTF-8")
    def initialize(directory)
      @directory = directory
      @targets = []
    end

    def add(icloud_name, image_names)
      image_names = [image_names].flatten
      @targets << [icloud_name, image_names]
    end

    def upload!
      tmpfile = nil
      uploader = nil
      script = SCRIPT.dup
      script.gsub!("/Users/dashboard/screenshots", File.expand_path(@directory))

      marker = 'tell me to refreshCloud("dashboard", {"sampletv"})'
      index = script.index(marker) + 1
      script.gsub!(marker, '')

      @targets.each do |tuple|
        icloud_name, image_names = tuple
        files = image_names.collect{ |name| "\"#{name}\"" }
        val = "\ttell me to refreshCloud(\"#{icloud_name}\", {#{files.join(", ")}})\n"
        script.insert(index, val)
      end

      tmpfile = Tempfile.new('applescript')
      tmpfile.write(script)
      tmpfile.close

      uploader = Tempfile.new('uploader')
      uploader.close

      puts "osacompile -o #{uploader.path} #{tmpfile.path}"
      puts `osacompile -o #{uploader.path} #{tmpfile.path}`

      puts "osascript #{uploader.path}"
      puts `osascript #{uploader.path}`
    ensure
      tmpfile.unlink  if tmpfile
      uploader.unlink if uploader
    end
  end
end
