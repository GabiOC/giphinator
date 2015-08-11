require 'pry'


def start_giphinator
  puts "Welcome! Here are your options:
  - search
  - trending
  - random
  - translate
  -exit"
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
  when "translate"
    translate
  when "exit"
    exit
  else
    puts "Please enter valid command: search, trending, random, stickers, translate"
  end
end

def search
  puts "SEARCH
  Please enter search term"
  answer = gets.chomp
  gif = Giphy::Client.new
  data = gif.search("#{answer}")
  puts get_url(data).sample
end

# search {
#   answer = gets.chomp
#   gif = Giphy::Client.new
# }

def trending
  puts "TRENDING
  Please enter number of results"
  answer = gets.chomp.to_i
  gif = Giphy::Client.new
  data = gif.trending(limit: answer)
  puts get_url(data)
end


def random
  puts "RANDOM"
  gif = Giphy::Client.new
  data = gif.random
  puts data["image_original_url"]
end


def translate
  puts "TRANSLATE
  Please enter phrase"
  answer = gets.chomp
  gif = Giphy::Client.new
  data = gif.translate("#{answer}")
  puts data["images"]["fixed_height"]["url"]
end

# def handle_gifing
#   answer = gets.chomp
#   gif = Giphy::Client.new
# end

def exit
  abort("Thanks for gifing!")
end

def get_url(data)
  arr = []
  data.each do |x|
  arr << x["images"]["fixed_height"]["url"]
  end
  arr
end



# gif = Giphy::Client.new

# data = gif.search("computer", {rating: "r"})

# binding.pry

## FOR TRANSLATE
# puts data["images"]["original"]["url"]

# arr = []

# data.each do |x|
#   arr << x["images"]["original"]["url"]
# end

# puts arr




