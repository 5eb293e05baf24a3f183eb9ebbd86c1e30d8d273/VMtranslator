# To change this template, choose Tools | Templates
# and open the template in the editor.

class Parser
  def initialize
    
  end
  
  def get_command_type command
    case command.split(" ").first
    when 'add', 'sub', 'neg', 'eq', 'gt', 'lt', 'and', 'or', 'not'
      :ARITHMETIC
    when 'push'
      :PUSH
    when 'pop'
      :POP
    when 'label'
      :LABEL
    when 'if-goto'
      :IF
    when 'goto'
      :GOTO
    when 'function'
      :FUNCTION
    when 'return'
      :RETURN
    end
    
  end
  
  def arg1 command
    command.split(" ")[1]
  end
  
  def arg2 command
    command.split(" ")[2]
  end
end
