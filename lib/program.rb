require 'pry'

def start_giphinator
  puts "Welcome! Here are your options:
  - search
  - trending
  - random
  - stickers
  - translate"
  answer = gets.chomp.downcase
  handle_response(answer)
end

def handle_response(answer)
  case answer
  when "search"
    search
  when "trending"
    trending
  when "random"
    random
  when "stickers"
    stickers
  when "translate"
    translate
  else
    puts "Please enter valid command: search, trending, random, stickers, translate"
  end
end

def search
  puts "SEARCH
  Please enter search term"
  answer = gets.chomp
  data = gif.search("#{answer}")
  binding.pry
  get_url(data)
end

def get_url(data)
  data.each do |x|
  arr << x["images"]["fixed_height"]["url"]
  end
  arr
end

