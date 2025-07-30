# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("fileutils")


# Changing Modelkit::Document to a module
# - need a different way to type-check the document or document_class arguments! ...multiple .respond_to? checks maybe?
# - allow Ruby to throw the NoMethodError if document methods are missing on the (former) subclasses.


module Modelkit

  # This class closely parallels file operations that would be initiated through a GUI.
  # This is a container for documents that wraps all File IO.
  class File

    # Create a new File from a Document class or an instance of a Document.
    # The File is unsaved until File#save_as is called.
    def self.new(argument)
      if (argument.class == Class)
        document_class = argument
        if (not document_class < Modelkit::Document)
          raise(ArgumentError, "argument is not a subclass of Modelkit::Document")
        else
          document = document_class.new
        end

      elsif (not argument.is_a?(Modelkit::Document))
        raise(ArgumentError, "argument is not an object ancestor of Modelkit::Document")

      else
        document = argument
      end

      file = self.allocate
      file.send(:initialize, document)
      return(file)
    end


    # Open an existing file on disk.
    # Would be great if 'open' could automatically figure out the appropriate document class.
    def self.open(path, document_class)
      if (path.class != String)
        raise(ArgumentError, "path argument is not a String")

      elsif (document_class.class != Class)
        raise(ArgumentError, "document_class argument is not a Class")

      elsif (not document_class < Modelkit::Document)
        raise(ArgumentError, "document_class argument is not a subclass of Modelkit::Document")

      elsif (not ::File.exist?(path))
        raise(ArgumentError, "path argument does not reference an existing file")
      end

      file = self.allocate
      file.send(:initialize, document_class.new)
      file.send(:open, path)
      return(file)
    end


    attr_reader :document


    def initialize(document)
      @path = nil
      @modified = false
      @closed = false
      @document = document
      @document.add_observer(self)
    end


    def path
      return(@path.dup if @path)
    end


    # Would prefer not to allow the path to be set externally--but Euclid needs it.
    def path=(path)
      @path = path
    end


    # Would prefer not to allow the modified floag to be set externally--but Euclid needs it.
    def modified=(status)
      @modified = status
    end


    # document_modified? (has the document been changed since last saved?)
    def modified?
      return(@modified)
    end

    # file modified on disk? (compare to Last Modified date on disk file)
    def file_modified?


    end


    def closed?
      return(@closed)
    end


    def document_class
      return(@document.class if @document)
    end


    # Throws away any changes and reload the saved file.
    def revert
      if(@path.nil?)
        raise(RuntimeError, "path is nil because the file has never been saved")

      elsif (not ::File.exist?(@path))
        raise(RuntimeError, "file does not exist at saved path and cannot be reverted")
      end

      open(@path)
      return(self)
    end


    # Save to the current path. Overwrites whatever was previously saved at the current path.
    def save
      if (closed?)
        raise(RuntimeError, "file is closed and cannot be saved")

      elsif(@path.nil?)
        raise(RuntimeError, "path is nil because the file has never been saved")

      #elsif (writeable)
        # Verify that path is writable: this is tricky because it depends on the full path existing
        # and possibly platform-specific permissions attributes.
        # If the path is not writable, it will fail eventually anyway.
      end

      FileUtils.mkdir_p(::File.dirname(@path))  # Ensure that all parent directories are created
      ::File.write(@path, @document.render)
      @modified = false
      return(self)
    end


    # Save to a new path while leaving the original file alone.
    # It's also the only way to set the path.
    def save_as(path, overwrite = false)
      if (path.class != String)
        raise(ArgumentError, "path argument is not a String")

      elsif (overwrite != true and overwrite != false)
        raise(ArgumentError, "overwrite argument is not true or false")

      elsif (closed?)
        raise(RuntimeError, "file is closed and cannot be saved")

      elsif (::File.exist?(path) and not overwrite)
        raise(RuntimeError, "file already exists at path and overwrite is false")

      #elsif (writeable)
        # Verify that path is writable: this is tricky because it depends on the full path existing
        # and possibly platform-specific permissions attributes.
        # If the path is not writable, it will fail eventually anyway.
      end

      @path = ::File.expand_path(path)
      save
      return(self)
    end


    # Close this file. It should not be necessary to close File instances as file handles are not kept open.
    # However, for very large documents it could/might be a performance benefit to call 'close' because this triggers garbage collection.
    # NOTE: This won't do much if there are other references to the Document object that still exist.
    def close(gc_start = false)
      if (not closed?)
        @path = nil
        @modified = false
        @closed = true
        @document.delete_observer(self)
        @document = nil
        GC.start if (gc_start)
      end
      return(self)
    end


    def update
      @modified = true
      puts "The file was changed!"
    end


    # Reports progress while reading/writing a file.
    def update_progress

    end

    # Merge another file with the same document class into this file.
#    def merge(other_path)
#      other_file = self.open(other_path)
#      @document.merge(other_file.document)
#      @modified = true
#    end


    # Imports data from a different document class into this one
    #file.import("new/path/name.idf", document_class = Modelkit::EnergyPlus)
    # if document_class is nil, the class is assumed to be the same.
    # like 'open', could also autodetect the document class.
#    def import(path, document_class = nil)

#    end

    #file.export_as("new/path/name.idf", document_class = Modelkit::EnergyPlus)
    # => new File object already saved; document_class defaults the same as original document--result is some info is lost
#    def export_as(path, document_class = nil)

#    end

  private

    # 'file.open' is a private method because we do not want to generally permit opening different paths into this document.
    # To open a file with a new document, use the constructor 'File.open'.
    def open(path)
      @path = ::File.expand_path(path)
      @document.parse(::File.read(@path))  # For very large files, this might need to be changed to a streaming approach
      @modified = false
      return(self)
    end

  end

end
