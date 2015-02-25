require "feedjira"

namespace :fetch do
  desc 'fetch feed'
  task feed: :environment do
    # puts Blog.last().to_yaml
    blogs = Blog.all
    feed = Feedjira::Parser::RSS.new
    blogs.each do |blog|
      last_entry_url = blog.articles.order("published DESC").first.url
      feed.feed_url = blog.url
      feed.last_modified = Time.zone.parse(blog.last_modified.to_s)
      # feed.last_modified = DateTime.parse(blog.last_modified.to_s)
      last_entry = Feedjira::Parser::RSSEntry.new
      last_entry.url = last_entry_url
      feed.entries = [last_entry]
      binding.pry

      updated_feed = Feedjira::Feed.update(feed)
      if updated_feed.updated?
        new_feed = updated_feed.new_entries
      end
      binding.pry
    end

    # binding.pry
  end
end