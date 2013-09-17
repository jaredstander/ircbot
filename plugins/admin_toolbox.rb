module Cinch::Plugins
  class AdminToolbox
    include Cinch::Plugin

    match(/add op (\w+)/, method: :add_op)
    match(/rm op (\w+)/, method: :rm_op)

    def initialize(*args)
      super
      @admins = CinchStorage.new(config[:filename] || 'yaml/admins.yml')
      @admins.data ||= Array.new
    end

    def add_op(m, user_name)
      return unless admin?(m.user, @admins.data)
      if !user_exists?(User(user_name), m.channel)
        m.reply("#{Format(:yellow, "Error: No such user #{User(user_name).nick}.")}")
      elsif admin?(User(user_name), @admins.data)
        m.reply("#{Format(:yellow, "#{User(user_name).nick} is already an op.")}")
      else
        @admins.data << User(user_name).mask.to_s.slice!((User(user_name).nick.length + 1), User(user_name).mask.to_s.length)
        @admins.synced_save(@bot)
        m.reply("#{Format(:yellow, "#{User(user_name).nick} is now an op.")}")
      end
    end

    def rm_op(m, user_name)
      return unless admin?(m.user, @admin.data)
      if admin?(m.user, @admin.data)
        @admins.data.delete(User(user_name).mask.to_s.slice!((User(user_name).nick.length + 1), User(user_name).mask.to_s.length))
        @admins.synced_save(@bot)
        m.reply("#{User(user_name).nick} has been removed from ops.")
      else
        m.reply("User is not a listed op.")
      end
    end

  end
end