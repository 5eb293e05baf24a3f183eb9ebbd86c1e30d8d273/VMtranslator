# To change this template, choose Tools | Templates
# and open the template in the editor.
$LOAD_PATH << File.dirname(__FILE__)
require "parser"
require "translator"

class VmTranslator
  # attr_reader (TEST purpose only)
  attr_reader :output_file
  
  def initialize input_name
    basename = File.basename(input_name, ".vm")
    dirname = File.dirname input_name
    @output_file = File.new("#{dirname}/#{basename}.asm", "w")
    
    if File.directory? input_name
      @filenames = "#{input_name}/*.vm"
    else
      @filenames = input_name
    end
    
    @parser = Parser.new
    @translator = Translator.new
  end
  
  def run
    #ini code
    @output_file.print @translator.init_code
    
    @filenames = @filenames.gsub("\\", '/') 
    Dir.glob(@filenames) do |filename|
      cur_func_name = nil      
      File.open(filename).each_line do |line|
        line = sanitize line
        next if line.empty?

        command_type = @parser.get_command_type line

        case command_type
        when :ARITHMETIC
          translation = @translator.arithmetic line
        when :PUSH, :POP
          arg1 = @parser.arg1 line
          arg2 = @parser.arg2 line
          file_basename = File.basename(filename, ".vm")
          translation = @translator.push_pop(command_type, arg1, arg2, file_basename)
        when :LABEL
          translation = @translator.label(@parser.arg1(line), cur_func_name)
        when :GOTO
          translation = @translator.goto(@parser.arg1(line), cur_func_name)
        when :IF
          translation = @translator.if_goto(@parser.arg1(line), cur_func_name)
        when :FUNCTION
          cur_func_name = @parser.arg1(line)
          translation = @translator.function(cur_func_name, @parser.arg2(line))
        when :RETURN
          translation = @translator.ret
        when :CALL
          translation = @translator.call(@parser.arg1(line), @parser.arg2(line))
        end
        
        @output_file.print translation
      end     
    end
    
    @output_file.close
  end
  
  private
    def sanitize str
      str.split("//").first.strip
    end
       
end


if __FILE__ == $0
  x = VmTranslator.new ARGV[0]
  x.run 
end
