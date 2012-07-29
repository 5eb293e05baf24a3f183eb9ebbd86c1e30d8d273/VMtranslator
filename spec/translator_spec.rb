# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'translator'

describe Translator do
  before(:each) do
    @translator = Translator.new
  end

  describe "arithmetic" do
    subject { @translator.arithmetic command }

    context "when the command is 'add'" do
      let(:command) { "add" }
      
      it "returns a correct translation" do
        correct_translation = "@SP\nAM=M-1\nD=M\n@SP\nAM=M-1\nM=M+D\n@SP\nM=M+1\n"    
        subject.should eq correct_translation
      end
    end
    
    context "when the command is 'sub'" do
      let(:command) { "sub" }
      
      it "returns a correct translation" do
        correct_translation = "@SP\nAM=M-1\nD=M\n@SP\nAM=M-1\nM=M-D\n@SP\nM=M+1\n"    
        subject.should eq correct_translation
      end
    end
    
    context "when the command is 'or'" do
      let(:command) { "or" }
      
      it "returns a correct translation" do
        correct_translation = "@SP\nAM=M-1\nD=M\n@SP\nAM=M-1\nM=D|M\n@SP\nM=M+1\n"    
        subject.should eq correct_translation
      end
    end
    
    context "when the command is 'neg'" do
      let(:command) { "neg" }
      
      it "returns a correct translation" do
        correct_translation = "@SP\nAM=M-1\nM=-M\n@SP\nM=M+1\n"    
        subject.should eq correct_translation
      end
    end
    
    context "when the command is 'not'" do
      let(:command) { "not" }
      
      it "returns a correct translation" do
        correct_translation = "@SP\nAM=M-1\nM=!M\n@SP\nM=M+1\n"    
        subject.should eq correct_translation
      end
    end
    
    context "when the command is 'eq'" do
      let(:command) { "eq" }
      
      it "returns a correct translation" do
        correct_translation = "@SP\nAM=M-1\nD=M\n@SP\nAM=M-1\nD=M-D\n@SP\nA=M\nM=-1\n@U1\nD;JEQ\n@SP\nA=M\nM=0\n(U1)\n@SP\nM=M+1\n"    
        subject.should eq correct_translation
      end
    end
    
    context "when the previous command was 'gt' and the current command is 'lt'" do
      before { @translator.arithmetic 'gt' }
      let(:command) { "lt" }
      
      it "returns a correct translation" do
        correct_translation = "@SP\nAM=M-1\nD=M\n@SP\nAM=M-1\nD=M-D\n@SP\nA=M\nM=-1\n@U2\nD;JLT\n@SP\nA=M\nM=0\n(U2)\n@SP\nM=M+1\n"    
        subject.should eq correct_translation
      end
    end
  end
  
  describe "push_pop" do
    subject { @translator.push_pop(command_type, segment, index, file_basename) }
    context "when the file_basename is 'foo'" do
      let(:file_basename) { 'foo' }
      
      context "when the command_type is :PUSH" do
        let(:command_type) { :PUSH }

        context "when the segment is 'constant'" do
          let(:segment) { "constant" }

          context "when the index is '17'" do
            let(:index) { "17" }

            it "returns a correct translation" do
              correct_translation = "@17\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '227'" do
            let(:index) { "227" }

            it "returns a correct translation" do
              correct_translation = "@227\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"    
              subject.should eq correct_translation
            end
          end
        end

        context "when the segment is 'local'" do
          let(:segment) { "local" }

          context "when the index is '0'" do
            let(:index) { "0" }

            it "returns a correct translation" do
              correct_translation = "@0\nD=A\n@LCL\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '2'" do
            let(:index) { "2" }

            it "returns a correct translation" do
              correct_translation = "@2\nD=A\n@LCL\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"  
              subject.should eq correct_translation
            end
          end
        end

        context "when the segment is 'argument'" do
          let(:segment) { "argument" }

          context "when the index is '0'" do
            let(:index) { "0" }

            it "returns a correct translation" do
              correct_translation = "@0\nD=A\n@ARG\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '2'" do
            let(:index) { "2" }

            it "returns a correct translation" do
              correct_translation = "@2\nD=A\n@ARG\nA=D+M\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"  
              subject.should eq correct_translation
            end
          end
        end

        context "when the segment is 'pointer'" do
          let(:segment) { "pointer" }

          context "when the index is '0'" do
            let(:index) { "0" }

            it "returns a correct translation" do
              correct_translation = "@THIS\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '1'" do
            let(:index) { "1" }

            it "returns a correct translation" do
              correct_translation = "@THAT\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"  
              subject.should eq correct_translation
            end
          end
        end

        context "when the segment is 'temp'" do
          let(:segment) { "temp" }

          context "when the index is '1'" do
            let(:index) { "1" }

            it "returns a correct translation" do
              correct_translation = "@R6\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '2'" do
            let(:index) { "2" }

            it "returns a correct translation" do
              correct_translation = "@R7\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"  
              subject.should eq correct_translation
            end
          end
        end

        context "when the segment is 'static'" do
          let(:segment) { "static" }

          context "when the index is '8'" do
            let(:index) { "8" }

            it "returns a correct translation" do
              correct_translation = "@foo.8\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '3'" do
            let(:index) { "3" }
            
            it "returns a correct translation" do
              correct_translation = "@foo.3\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"  
              subject.should eq correct_translation
            end
          end
        end
      end 
      
      context "when the command_type is :POP" do
        let(:command_type) { :POP }

        context "when the segment is 'local'" do
          let(:segment) { "local" }

          context "when the index is '3'" do
            let(:index) { "3" }

            it "returns a correct translation" do
              correct_translation = "@3\nD=A\n@LCL\nD=D+M\n@R13\nM=D\n@SP\nAM=M-1\nD=M\n@R13\nA=M\nM=D\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '0'" do
            let(:index) { "0" }

            it "returns a correct translation" do
              correct_translation = "@0\nD=A\n@LCL\nD=D+M\n@R13\nM=D\n@SP\nAM=M-1\nD=M\n@R13\nA=M\nM=D\n"  
              subject.should eq correct_translation
            end
          end
        end

        context "when the segment is 'this'" do
          let(:segment) { "this" }

          context "when the index is '1'" do
            let(:index) { "1" }

            it "returns a correct translation" do
              correct_translation = "@1\nD=A\n@THIS\nD=D+M\n@R13\nM=D\n@SP\nAM=M-1\nD=M\n@R13\nA=M\nM=D\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '7'" do
            let(:index) { "7" }

            it "returns a correct translation" do
              correct_translation = "@7\nD=A\n@THIS\nD=D+M\n@R13\nM=D\n@SP\nAM=M-1\nD=M\n@R13\nA=M\nM=D\n"  
              subject.should eq correct_translation
            end
          end
        end

        context "when the segment is 'temp'" do
          let(:segment) { "temp" }

          context "when the index is '1'" do
            let(:index) { "1" }

            it "returns a correct translation" do
              correct_translation = "@SP\nAM=M-1\nD=M\n@R6\nM=D\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '5'" do
            let(:index) { "5" }

            it "returns a correct translation" do
              correct_translation = "@SP\nAM=M-1\nD=M\n@R10\nM=D\n"  
              subject.should eq correct_translation
            end
          end
        end

        context "when the segment is 'static'" do
          let(:segment) { "static" }

          context "when the index is '2'" do
            let(:index) { "2" }

            it "returns a correct translation" do
              correct_translation = "@SP\nAM=M-1\nD=M\n@foo.2\nM=D\n"    
              subject.should eq correct_translation
            end
          end

          context "when the index is '8'" do
            let(:index) { "8" }

            it "returns a correct translation" do
              correct_translation = "@SP\nAM=M-1\nD=M\n@foo.8\nM=D\n"  
              subject.should eq correct_translation
            end
          end
        end 
      end      
    end
  end
  
  describe "label" do
    subject { @translator.label str }
    
    context "when the str is 'LOOP_START'" do
      let(:str) { "LOOP_START" }
      
      it "returns a correct translation" do
        subject.should eq "(LOOP_START)\n"
      end
    end
    
    context "when the str is 'END_PROGRAM'" do
      let(:str) { "END_PROGRAM" }
      
      it "returns a correct translation" do
        subject.should eq "(END_PROGRAM)\n"
      end
    end
  end
  
  describe "goto" do
    subject { @translator.goto label }
    
    context "when the label is 'LOOP_START'" do
      let(:label) { "LOOP_START" }
      
      it "returns a correct translation" do
        subject.should eq "@LOOP_START\n0;JMP\n"
      end
    end

    context "when the label is 'END_PROGRAM'" do
      let(:label) { "END_PROGRAM" }
      
      it "returns a correct translation" do
        subject.should eq "@END_PROGRAM\n0;JMP\n"
      end
    end    
  end
  
  describe "if_goto" do
    subject { @translator.if_goto label }
    
    context "when the label is 'LOOP_START'" do
      let(:label) { "LOOP_START" }
      
      it "returns a correct translation" do
        subject.should eq "@SP\nAM=M-1\nD=M\n@LOOP_START\nD;JNE\n"
      end
    end

    context "when the label is 'END_PROGRAM'" do
      let(:label) { "END_PROGRAM" }
      
      it "returns a correct translation" do
        subject.should eq "@SP\nAM=M-1\nD=M\n@END_PROGRAM\nD;JNE\n"
      end
    end    
  end
  
  describe "function" do
    subject { @translator.function(name, nLocals) }
    
    context "when the name is 'SimpleFunction.test'" do
      let(:name) { "SimpleFunction.test" }
      
      context "when the nLocals is '2'" do
        let(:nLocals) { '2' }
        
        it "returns a correct translation" do
          subject.should eq "(SimpleFunction.test)\n" + "@0\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n" * 2
        end
      end
      
      context "when the nLocals is '5'" do
        let(:nLocals) { '5' }
        
        it "returns a correct translation" do
          subject.should eq "(SimpleFunction.test)\n" + "@0\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n" * 5
        end
      end
      
      context "when the nLocals is '0'" do
        let(:nLocals) { '0' }
        
        it "returns a correct translation" do
          subject.should eq "(SimpleFunction.test)\n" + "@0\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n" * 0
        end
      end
    end
    
    context "when the name is 'Main.fibonacci'" do
      let(:name) { "Main.fibonacci" }
      
      context "when the nLocals is '2'" do
        let(:nLocals) { '2' }
        
        it "returns a correct translation" do
          subject.should eq "(Main.fibonacci)\n" + "@0\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n" * 2
        end
      end
    end
  end
  
  describe "ret" do
    subject { @translator.ret }
    
    it "returns a correct translation" do
    subject.should eq "@LCL\nD=M\n@R15\nM=D\n" + "@5\nD=A\n@R15\nA=M-D\nD=M\n@R14\nM=D\n" + "@0\nD=A\n@ARG\nD=D+M\n@R13\nM=D\n@SP\nAM=M-1\nD=M\n@R13\nA=M\nM=D\n" +
      "@ARG\nD=M+1\n@SP\nM=D\n" + "@1\nD=A\n@R15\nA=M-D\nD=M\n@THAT\nM=D\n" + "@2\nD=A\n@R15\nA=M-D\nD=M\n@THIS\nM=D\n" + 
      "@3\nD=A\n@R15\nA=M-D\nD=M\n@ARG\nM=D\n" + "@4\nD=A\n@R15\nA=M-D\nD=M\n@LCL\nM=D\n" + "@R14\nA=M\n0;JMP\n"  
    end    
  end
  
end

