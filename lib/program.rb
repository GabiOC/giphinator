require 'pry'


def start_giphinator
  puts "Here are your options:
  - search
  - trending
  - random
  - translate
  - exit"
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
    answer = gets.chomp.downcase
    handle_response(answer)
  end
end

def search
  puts "SEARCH
  Please enter search term"
  answer = gets.chomp
  gif = Giphy::Client.new
  data = gif.search("#{answer}")
  url = get_url(data).sample
  puts "Here is the link: 
  #{url}"
  open_choice(url)
end

def trending
  puts "TRENDING
  Please enter number of results"
  answer = gets.chomp.to_i
  gif = Giphy::Client.new
  data = gif.trending(limit: answer)
  url = get_url(data)
  puts "Here are the links:"
  url.each_with_index do |item, index|
    puts "#{index+1}. #{item}"
  end
  open_trending(url)
end

def random
  puts "RANDOM"
  gif = Giphy::Client.new
  data = gif.random
  url = data["image_original_url"]
  puts "Here is the link: 
  #{url}"
  open_choice(url)
end

def translate
  puts "TRANSLATE
  Please enter phrase"
  answer = gets.chomp
  gif = Giphy::Client.new
  data = gif.translate("#{answer}")
  url = data["images"]["fixed_height"]["url"]
  puts "Here is the link: 
  #{url}"
  open_choice(url)
end

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

def open_url(url)
  cmd = "open #{url}"
  `#{cmd}`
end

def open_choice(url)
  puts "Would you like to open? (yes/no)"
  answer = gets.chomp.downcase
  if answer == "yes"
    open_url(url)
    start_giphinator
  elsif answer == "no"
    start_giphinator
  else
    puts "Enter yes or no dummy!"
    open_choice(url)
  end
end

def open_trending(url)
   puts "Do you want to open one? (yes/no)"
  answer = gets.chomp.downcase
  if answer == "yes"
    puts "Which one do you want to open? (type number)"
    answer = gets.chomp.to_i
    choice = url[answer-1]
    open_url(choice)
    start_giphinator
  elsif answer == "no"
    start_giphinator
  else puts "Enter yes or no dummy!"
    open_trending(url)
  end
end



