# Main file for the IRC bot.

# Require cinch to use the cinch IRC bot framework
require "cinch"
require "open-uri"
require "nokogiri"
require_relative "helpers/check_user"
require_relative "plugins/admin_toolbox"
require_relative "plugins/auto_op"
require_relative "plugins/dice_custom"
require_relative "plugins/haiku_custom"
require_relative "plugins/karma_custom"
require_relative "plugins/priv_toolbox"
require_relative "plugins/set_topic"
require_relative "plugins/show_url_title"

# Instantiate a new bot
bot = Cinch::Bot.new do
  configure do |c|
    # set configuration options
    c.verbose
    c.realname = "IRC Bot"
    c.nick     = "chanbot"
    c.server   = "localhost"
    c.channels = ["#test"]
    c.plugins.plugins = [Cinch::Plugins::AdminToolbox,
                         Cinch::Plugins::AutoOP,
                         Cinch::Plugins::DiceRollCustom,
                         Cinch::Plugins::HaikuCustom,
                         Cinch::Plugins::KarmaCustom,
                         Cinch::Plugins::PrivToolbox,
                         Cinch::Plugins::SetTopic,
                         Cinch::Plugins::ShowURLTitle]
    c.plugins.options[Cinch::Plugins::HaikuCustom] = {:delay => 1}
    c.shared[:cooldown] = { :config => { '#totaltest' => { :global => 1, :user => 20 } } }
  end

  # Welcome new users when they join a channel with a sample of welcome messages.
  on :join do |m|
    unless m.user.nick == bot.nick
      m.reply("#{Format(:yellow, "Welcome, #{m.user.nick}!")}", true)
    end
  end
end

bot.start