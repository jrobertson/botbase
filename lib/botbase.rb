#!/usr/bin/env ruby

# file: botbase.rb


require 'mtlite'
require 'simple-config'


class BotBase

  attr_reader :log
  attr_accessor :channel_lock, :message_prefix

  def initialize(config=nil, botname: 'Nicole', notifier: nil, log: nil,
                 debug: false)

    @botname, @notifier, @log, @h, @debug = botname, notifier, log, nil, debug

    if config then

      @h = SimpleConfig.new(config).to_h
      puts '@h: ' + @h.inspect if @debug
      @modules = initialize_modules(@h[:modules])

    end

  end

  # displays debug messages from modules
  #
  def notice(msg)
    @notifier.notice msg if @notifier
    puts msg
  end

  def received(sender='user01', msg, mode: :voicechat, echo_node: 'node1')

    msg.rstrip!

    if msg.downcase == 'exit' then
      @channel_lock, @message_prefix = nil, nil
    end

    log.info 'BotBase/received: ' + msg if log
    self.restart if msg == @botname + ' restart'

    r = nil

    detected = if @channel_lock then

      if @debug then
        notice 'botbase: inside channel locked'
        notice 'botbase: fullmsg:' + (@message_prefix.to_s + msg).inspect
      end

      r = @modules[@channel_lock].query(@message_prefix.to_s + msg,
                                        mode: mode, echo_node: echo_node)
      puts 'r: ' + r.inspect if @debug
      r and r.length > 0

    else

      if @debug then
        puts 'before modules.detect'
        puts '@modules.values: ' + @modules.values\
            .map {|x| x.inspect[0..100] }.join("\n")
      end

      @modules.detect do |name, obj|
        puts 'name: ' + name.inspect if @debug
        r = obj.query(msg, mode: mode, echo_node: echo_node)
        r and r.length > 0
      end

    end


    if detected then

      puts 'detected: ' + detected.inspect[0..200] + ' ...' if @debug

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

    a = modules.map do |name, settings|

      settings = {} if settings.is_a? String

      if log then
        log.info 'BotBase/initialize_modules: ' +
            'initialising botbase-module-'  + name.to_s
      end

      klass_name = 'BotBaseModule' + name.to_s

      [name, Kernel.const_get(klass_name).new(**settings.merge({callback: self,
                                                              debug: @debug}))]

    end

    puts 'a: ' + a[0..100].inspect if @debug
    a.to_h


  end

end
