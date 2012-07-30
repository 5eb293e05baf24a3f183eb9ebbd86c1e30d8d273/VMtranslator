# To change this template, choose Tools | Templates
# and open the template in the editor.

class Translator
  def initialize
    @unique_symbol_counter = 0
    
    @ram_map = { 
      'local' => 'LCL',
      'argument' => 'ARG',
      'this' => 'THIS',
      'that' => 'THAT',
      'pointer0' => 'THIS',
      'pointer1' => 'THAT',
      'temp0' => 'R5',
      'temp1' => 'R6',
      'temp2' => 'R7',
      'temp3' => 'R8',
      'temp4' => 'R9',
      'temp5' => 'R10',
      'temp6' => 'R11',
      'temp7' => 'R12',
    }
  end
  
  def arithmetic command
    if binary_operation? command
      case command
      when 'add'
        comp = "M+D"
      when 'sub'
        comp = "M-D"
      when 'and'
        comp = 'D&M'
      when 'or'
        comp = 'D|M'
      end
      "@SP\nAM=M-1\nD=M\n@SP\nAM=M-1\nM=#{comp}\n@SP\nM=M+1\n"      
    elsif unary_operation? command
      case command
      when 'neg'
        comp = '-M'
      when 'not'
        comp = '!M'
      end 
      "@SP\nAM=M-1\nM=#{comp}\n@SP\nM=M+1\n"  
    else
      case command
      when 'eq'
        jump = 'JEQ'
      when 'gt'
        jump = 'JGT'
      when 'lt'
        jump = 'JLT'
      end
      unique_symbol_counter = next_unique_symbol_counter
      "@SP\nAM=M-1\nD=M\n@SP\nAM=M-1\nD=M-D\n@SP\nA=M\nM=-1\n@U#{unique_symbol_counter}\nD;#{jump}\n@SP\nA=M\nM=0\n(U#{unique_symbol_counter})\n@SP\nM=M+1\n"  
    end
  end
  
  def push_pop(command_type, segment, index, file_basename)
    case command_type
    when :PUSH
      if segment == "constant"
        "@#{index}\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
      elsif segment == "pointer" or segment == "temp"
        "@#{@ram_map[segment + index]}\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
      elsif segment == "static"
        "@#{file_basename}.#{index}\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
      else
        "@#{index}\nD=A\n@#{@ram_map[segment]}\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
      end      
    when :POP
      if segment == "pointer" or segment == "temp"
        "@SP\nAM=M-1\nD=M\n@#{@ram_map[segment + index]}\nM=D\n"
      elsif segment == "static"
        "@SP\nAM=M-1\nD=M\n@#{file_basename}.#{index}\nM=D\n"  
      else
        "@#{index}\nD=A\n@#{@ram_map[segment]}\nD=D+M\n@R13\nM=D\n@SP\nAM=M-1\nD=M\n@R13\nA=M\nM=D\n"        
      end    
    end 
  end
  
  def label str
    "(#{str})\n"
  end
  
  def goto label
    "@#{label}\n0;JMP\n"
  end
  
  def if_goto label
    "@SP\nAM=M-1\nD=M\n@#{label}\nD;JNE\n"
  end
  
  def function(name, nLocals)
    "(#{name})\n" + "@0\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n" * Integer(nLocals)
  end
  
  def ret
    "@LCL\nD=M\n@R15\nM=D\n" + "@5\nD=A\n@R15\nA=M-D\nD=M\n@R14\nM=D\n" + "@0\nD=A\n@ARG\nD=D+M\n@R13\nM=D\n@SP\nAM=M-1\nD=M\n@R13\nA=M\nM=D\n" +
    "@ARG\nD=M+1\n@SP\nM=D\n" + "@1\nD=A\n@R15\nA=M-D\nD=M\n@THAT\nM=D\n" + "@2\nD=A\n@R15\nA=M-D\nD=M\n@THIS\nM=D\n" + 
    "@3\nD=A\n@R15\nA=M-D\nD=M\n@ARG\nM=D\n" + "@4\nD=A\n@R15\nA=M-D\nD=M\n@LCL\nM=D\n" + "@R14\nA=M\n0;JMP\n"    
  end
  
  private
  def binary_operation? command
    true if ['add', 'sub', 'and', 'or'].include? command
  end
  
  def unary_operation? command
    true if ['neg', 'not'].include? command
  end
  
  def next_unique_symbol_counter
    @unique_symbol_counter = @unique_symbol_counter + 1
  end
end