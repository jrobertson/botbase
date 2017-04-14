#!/usr/bin/env ruby

# file: botbase.rb


require 'simple-config'



class BotBase
  
  def initialize(config=nil, botname: 'Nicole')

    @h = nil

    if config then
      
      @h = SimpleConfig.new(config).to_h      

      # load the service modules
      @modules = initialize_modules(@h[:modules])
      
    end
    
    @botname = botname

  end
  
  def received(sender='user01', msg)

    self.restart if msg == @botname + ' restart'
    
    r = nil
    
    msg_recognised = @modules.detect {|m| r = m.query msg }
    
    return r if msg_recognised
    
    ''

  end

  def restart

    puts 'restarting ...'
    @modules = initialize_modules(@h[:modules]) if @h
          
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