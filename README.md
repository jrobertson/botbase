# Introducing the BotBase gem

    require 'botbase-module-rsc'
    require 'botbase-module-demo'
    require 'botbase'

    bot = BotBase.new('http://www.jamesrobertson.eu/botbase.conf')
    bot.received 'tim'
    #=> "<job>2016-07-30 15:19:58 +0100</job>"

    bot.received 'hello?'
    #=> "hello user01, how can I help you?"

## Resources

* botbase https://rubygems.org/gems/botbase

## See also

* Introducing the sps_bot gem http://www.jamesrobertson.eu/snippets/2015/nov/16/introducing-the-sps_bot-gem.html

botbase chat bot gem
