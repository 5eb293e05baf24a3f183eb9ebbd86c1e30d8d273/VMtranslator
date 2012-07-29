Feature: Generate a .asm file according to the .vm input file(s)

    Scenario: single file
        Given a command line interface
        When a user types 'ruby path/to/VMtranslator/vm_translator.rb "/home/lion/Downloads/HWprojects/07/StackArithmetic/SimpleAdd/SimpleAdd.vm"'
        And he clicks ENTER
        Then there should be "/home/lion/Downloads/HWprojects/07/StackArithmetic/SimpleAdd/SimpleAdd.asm"
        
    Scenario: multiple files (directory)
        Given a command line interface
        When a user types 'ruby path/to/VMtranslator/vm_translator.rb "/home/lion/Downloads/HWprojects/07/StackArithmetic/SimpleAdd"'
        And he clicks ENTER
        Then there should be "/home/lion/Downloads/HWprojects/07/StackArithmetic/SimpleAdd.asm"        