# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'parser'

describe Parser do
  before(:each) do
    @parser = Parser.new
  end

  describe "get_command_type" do
    subject { @parser.get_command_type command }
    
    context "when the command is 'add', 'sub', 'neg', 'eq', 'gt', 'lt', 'and', 'or' or 'not'" do
      it "should return :ARITHMETIC" do
        ['add', 'sub', 'neg', 'eq', 'gt', 'lt', 'and', 'or', 'not'].each do |command|
          @parser.get_command_type(command).should eq :ARITHMETIC 
        end
      end
    end
    
    context "when the command is 'push local 3'" do
      let(:command) { "push local 3" }
      
      it "should return :PUSH" do
        subject.should eq :PUSH
      end
    end
    
    context "when the command is 'pop temp 0'" do
      let(:command) { "pop temp 0" }
      
      it "should return :POP" do
        subject.should eq :POP
      end
    end
    
    context "when the command is 'label LOOP_START'" do
      let(:command) { "label LOOP_START" }
      
      it "should return :LABEl" do
        subject.should eq :LABEL
      end
    end
    
    context "when the command is 'if-goto LOOP_START'" do
      let(:command) { "if-goto LOOP_START" }
      
      it "should return :IF" do
        subject.should eq :IF
      end
    end
    
     
    context "when the command is 'goto END_PROGRAM'" do
      let(:command) { "goto END_PROGRAM" }
      
      it "should return :GOTO" do
        subject.should eq :GOTO
      end
    end

    context "when the command is 'function SimpleFunction.test 2'" do
      let(:command) { "function SimpleFunction.test 2" }
      
      it "should return :FUNCTION" do
        subject.should eq :FUNCTION
      end
    end   
    
    context "when the command is 'return'" do
      let(:command) { "return" }
      
      it "should return :RETURN" do
        subject.should eq :RETURN
      end
    end 
    
    
  end
  
  describe "arg1" do
    subject { @parser.arg1 command }
    
    context "when the command is 'push this 3'" do
      let(:command) { "push this 3" }
      
      it "should return 'this'" do
        subject.should eq "this"
      end
    end
    
    context "when the command is 'add'" do
      let(:command) { "add" }
      
      it "should return nil" do
        subject.should eq nil
      end
    end
    
    context "when the command is 'label LOOP_START'" do
      let(:command) { "label LOOP_START" }
      
      it "should return 'LOOP_START'" do
        subject.should eq 'LOOP_START'
      end
    end
    
    context "when the command is 'goto END_PROGRAM'" do
      let(:command) { "goto END_PROGRAM" }
      
      it "should return 'END_PROGRAM'" do
        subject.should eq 'END_PROGRAM'
      end
    end
    
    context "when the command is 'if-goto LOOP_START'" do
      let(:command) { "if-goto LOOP_START" }
      
      it "should return 'LOOP_START'" do
        subject.should eq 'LOOP_START'
      end
    end
  end
  
  describe "arg2" do
    subject { @parser.arg2 command }
    
    context "when the command is 'pop local 1'" do
      let(:command) { "pop local 1" }
      
      it "should return 1" do
        subject.should eq '1'
      end
    end
    
    context "when the command is 'and'" do
      let(:command) { "and" }
      
      it "should return nil" do
        subject.should eq nil
      end
    end
  end
end

