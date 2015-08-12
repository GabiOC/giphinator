

require 'pry'

class Commands
  attr_accessor :gif

  def initialize
    @gif = Giphy::Client.new
  end

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
      puts "Please enter valid command: search, trending, random, translate"
      answer = gets.chomp.downcase
      handle_response(answer)
    end
  end

  def search
    puts "SEARCH
    Please enter search term"
    answer = gets.chomp.downcase
    @gif
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
    @gif
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
    @gif
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
    @gif
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
    puts "Would you like to preview or open in browser? (preview/browser/no)"
    answer = gets.chomp.downcase
    if answer == "preview"
      preview(url)
    elsif answer == "browser"
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

  def preview(url)
    @gif = MiniMagick::Image.open(url)

    @gif.frames.each_with_index do |frame, idx|
      frame.write("images/frame#{idx}.jpg")
    end       #creates frame files in images folder from url

    num_frames = gif.frames.count
    frames = num_frames.times.map {|f| "images/frame#{f}.jpg"}

    frames.cycle.each do |frame|
    a = AsciiArt.new(frame)
    puts a.to_ascii_art
    #  (color: true)
    #  exit false if gets.chomp.empty?
    end
    FileUtils.rm_rf(Dir.glob('images/*'))   #deletes image files
    browser_choice(url)
  end

   def browser_choice(url)
    puts "Do you want to open in browser? (yes/no)"
    answer = gets.chomp.downcase
   if answer == "yes"
      open_url(url)
      start_giphinator
    elsif answer == "no"
      start_giphinator
   else puts "Enter yes or no dummy!"
      browser_choice(url)
    end
  end
end
