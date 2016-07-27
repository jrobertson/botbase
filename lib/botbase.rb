#!/usr/bin/env ruby

# file: botbase.rb


require 'simple-config'



class BotBase
  
  def initialize(config=nil)


    if config then
      
      h = SimpleConfig.new(config).to_h      
      
      # load the service modules
      @modules = initialize_modules(h[:modules])
      
    end

  end
  
  def received(sender='user01', msg)

    r = nil
    msg_recognised = @modules.detect do |m|
      r = m.query msg
    end
    
    return r if msg_recognised
    
    ''

  end  
  
  private
  
  def initialize_modules(modules)
    
    modules.inject([]) do |r, m|
      
      name, settings = m
            
      klass_name = 'BotBaseModule' + name.to_s

      r << Kernel.const_get(klass_name).new(settings)

    end
        
  end  

    
end
