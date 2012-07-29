After do
  output_file = "/home/lion/Downloads/HWprojects/07/StackArithmetic/SimpleAdd/SimpleAdd.asm"
  File.delete output_file if File.exists? output_file
  
  output_file = "/home/lion/Downloads/HWprojects/07/StackArithmetic/SimpleAdd.asm"
  File.delete output_file if File.exists? output_file
end
