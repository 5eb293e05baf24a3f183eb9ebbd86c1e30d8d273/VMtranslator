Given /^a command line interface$/ do
 
end

When /^a user types 'ruby path\/to\/VMtranslator\/vm_translator\.rb "(.*?)"'$/ do |vm_input_file|
  ARGV[0] = vm_input_file
end

When /^he clicks ENTER$/ do
  vm_translator = VmTranslator.new ARGV[0]
  vm_translator.run
end

Then /^there should be "(.*?)"$/ do |asm_output_file|
  File.exists?(asm_output_file).should be_true
end


