#!/usr/bin/env ruby

# file: botbase.rb


require 'mtlite'
require 'simple-config'


class BotBase  
  
  attr_reader :log
  
  
  def initialize(config=nil, botname: 'Nicole', notifier: nil, log: nil)

    @botname, @notifier, @log, @h = botname, notifier, log, nil
    
    if config then
      
      @h = SimpleConfig.new(config).to_h      
      @modules = initialize_modules(@h[:modules])
      
    end

  end
  
  # used for display debug messages from modules
  #
  def notice(msg)
    @notifier.notice msg if @notifier
  end  
  
  def received(sender='user01', msg, mode: :voicechat, echo_node: 'node1')

    msg.rstrip!
    
    log.info 'BotBase/received: ' + msg if log
    self.restart if msg == @botname + ' restart'
    
    r = nil
    
    detected = @modules.detect do |m| 
      r = m.query(msg, mode: mode, echo_node: echo_node)
      r and r.length > 0 
    end
    
    if detected then
      
      if mode == :voicechat then
        MTLite.new(r).to_s.gsub(/ +https:\/\/[\S]+/,'')
      else
        MTLite.new(r).to_html
      end

    else
      ''
    end

  end

  def restart

    log.info 'BotBase/restart: restarting ...' if log
    @modules = initialize_modules(@h[:modules]) if @h
    notice "echo: #{@botname} is now ready"
          
  end
  
  private
  
  def initialize_modules(modules)
    
    modules.inject([]) do |r, m|
      
      name, settings = m
      settings = {} if settings.is_a? String
      
      if log then
        log.info 'BotBase/initialize_modules: ' + 
            'initialising botbase-module-'  + name.to_s
      end
            
      klass_name = 'BotBaseModule' + name.to_s
      
      r << Kernel.const_get(klass_name).new(settings.merge({callback: self}))

    end
        
  end  
    
end