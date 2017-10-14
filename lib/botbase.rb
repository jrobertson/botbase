#!/usr/bin/env ruby

# file: botbase.rb


require 'simple-config'



class BotBase
  
  def initialize(config=nil, botname: 'Nicole', notifier: nil, debug: false)

    @h = nil

    @botname, @notifier, @debug = botname, notifier, debug
    
    if config then
      
      @h = SimpleConfig.new(config).to_h      
      puts 'j:' + @h.inspect
      # load the service modules
      @modules = initialize_modules(@h[:modules])
      
    end

  end
  
  # used for display debug messages from modules
  #
  def debug(msg)
    notice 'botbase/debug: ' + msg if @debug
  end
  
  # used for display debug messages from modules
  #
  def notice(msg)
    @notifier.notice msg if @notifier
  end  
  
  def received(sender='user01', msg, mode: :voicechat, echo_node: 'node1')

    msg.rstrip!
    self.restart if msg == @botname + ' restart'
    
    r = nil
    
    detected = @modules.detect do |m| 
      r = m.query(msg, mode: mode, echo_node: echo_node)
      r and r.length > 0 
    end
    
    if detected then
      r 
    else
      ''
    end

  end

  def restart

    puts 'restarting ...'
    @modules = initialize_modules(@h[:modules]) if @h
    notice "echo: #{@botname} is now ready"
          
  end
  
  private
  
  def initialize_modules(modules)
    
    modules.inject([]) do |r, m|
      
      name, settings = m
      
      debug 'initialising botbase-module-'  + name.to_s
            
      klass_name = 'BotBaseModule' + name.to_s

      
      r << Kernel.const_get(klass_name).new(settings.merge({callback: self}))

    end
        
  end  

    
end