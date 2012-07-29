#! /usr/bin/env ruby
@LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "vm_translator"

vm_translator = VmTranslator.new
vm_translator.run
