module Serverspec::Type
  class MultiFile < Base
    attr_accessor :content

    def multi_file?
      puts @name
    end
  end
end

# @paths.map{|path| @runner.get_file_content(path) }.join("\n")