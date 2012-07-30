# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'vm_translator'

describe VmTranslator do
  before(:each) do
    @vm_translator = VmTranslator.new input_name
    
    Parser.any_instance.stub(:get_command_type).and_return(:ARITHMETIC)
    Parser.any_instance.stub(:get_arg1).and_return("local")
    Parser.any_instance.stub(:get_arg2).and_return(2)
  end
  
  describe "output file" do
    subject { @vm_translator.output_file }
    
    context "when the input is a directory name" do
      before { subject.close }
      let(:input_name) { 'D:/VMtranslator/spec/file_mocks/vms' }
          
      it "has the '.asm' extension" do
        File.extname(subject.path).should eq ".asm"
      end
    
      it "has the same basename as that of the input file" do
        input_file_basename = File.basename(input_name, ".vm")
        out_file_basename = File.basename(subject.path, ".asm")
        out_file_basename.should eq input_file_basename
      end
      
      it "has the same dirname as that of the input file" do
        input_file_dirname = File.dirname input_name
        out_file_dirname = File.dirname subject.path
        out_file_dirname.should eq input_file_dirname
      end
      
    end
  end
  
  describe "run" do
    subject { @vm_translator.run }
    
    context "when the translator returns 2 lines for each line in the input file" do
      before do
        Translator.any_instance.stub(:arithmetic).and_return("translation\ntranslation\n")
      end
      
      context "when the input is a single file" do
        context "when the input file has 10 real lines" do
          let(:input_name) { 'D:/VMtranslator/spec/file_mocks/10_real_lines.vm' }

          it "makes the output file have 20 lines" do 
            subject

            output_file_lines = 0
            File.open(@vm_translator.output_file.path).each_line do |line|
              output_file_lines = output_file_lines + 1
            end
            output_file_lines.should eq 20
          end
        end

        context "when the input file has 5 real lines and 5 unsignificant lines" do
          let(:input_name) { 'D:/VMtranslator/spec/file_mocks/5_real_5_unsignificant_lines.vm' }

          it "makes the output file have 10 lines" do 
            subject

            output_file_lines = 0
            File.open(@vm_translator.output_file.path).each_line do |line|
              output_file_lines = output_file_lines + 1
            end
            output_file_lines.should eq 10
          end
          
        end        
      end
      
      context "when the input is a directory" do
        context "when the first file has 10 real lines and the second has 5 real lines and 5 unsignificant lines" do
          let(:input_name) { 'D:/VMtranslator/spec/file_mocks/vms' }
          
          it "makes the output file have 30 lines" do
            subject
            
            output_file_lines = 0
            File.open(@vm_translator.output_file.path).each_line do |line|
              output_file_lines = output_file_lines + 1
            end
            output_file_lines.should eq 30
          end
        end
      end

    end

  end
  
  after(:each) do
    #File.delete @vm_translator.output_file.path
  end
end

