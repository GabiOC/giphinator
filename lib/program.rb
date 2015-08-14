require 'pry'

class Commands
  attr_accessor :gif, :gifm

  def initialize
    @gif = Giphy::Client.new
  end

  def start_giphinator
    puts "~THE GIPHINATOR~
    Here are your options:
      Search
      Trending
      Random
      Translate
      Custom
      Exit"
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
    when "custom"
      Custom.new
    when "exit"
      exit
    else
      puts "Please enter valid command: search, trending, random, translate"
      answer = gets.chomp.downcase
      handle_response(answer)
    end
  end

  ## RESPONSE HANDLING METHODS
  def search
    puts "SEARCH
    Please enter search term"
    answer = gets.chomp.downcase
    @gif
    data = @gif.search("#{answer}")
    url = get_url(data).sample
    puts "Here is the link:
    #{url}"
    preview_or_browser(url)
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
    preview_or_browser(url)
  end

  def translate
    puts "TRANSLATE
    Please enter phrase"
    answer = gets.chomp.downcase
    @gif
    data = gif.translate("#{answer}")
    url = data["images"]["fixed_height"]["url"]
    puts "Here is the link:
    #{url}"
    preview_or_browser(url)
  end

  def custom
    puts "CUSTOM
    Input your own gif url"
    answer = gets.chomp.downcase
    preview_or_browser(answer)
  end

  def exit
    abort("Thanks for gifing!")
  end

  ## EXTRACT URL FROM GIF OBJECT
  def get_url(data)
    arr = []
    data.each do |x|
    arr << x["images"]["fixed_height"]["url"]
    end
    arr
  end

  ## HANDLE TRENDING VIEWING CHOICE
  def open_trending(url)
     puts "Do you want to open one? (yes/no)"
    answer = gets.chomp.downcase
    if answer == "yes"
      trending_number_choice(url)
    elsif answer == "no"
      start_giphinator
    else puts "Enter yes or no, dummy!"
      open_trending(url)
    end
  end

  ## SELECT WHICH TRENDING GIF TO VIEW
  def trending_number_choice(url)
      puts "Which one do you want to open? (type number)"
      answer = gets.chomp.to_i
      if answer > 0 && answer <= url.length
        choice = url[answer-1]
        preview_or_browser(choice)
      else puts "Enter a valid number!"
        trending_number_choice(url)
      end
  end

  ## VIEWING CHOICE
  def preview_or_browser(url)
    puts "Would you like to preview in terminal or open in browser? (preview/browser/no)"
    answer = gets.chomp.downcase
    if answer == "preview"
      puts "(may take a few seconds to load)"
      create_frames(url)
    elsif answer == "browser"
      open_url(url)
      start_giphinator
    elsif answer == "no"
      start_giphinator
    else
      puts "Enter yes or no dummy!"
      preview_or_browser(url)
    end
  end

  ## OPEN URL IN BROWSER
  def open_url(url)
    cmd = "open #{url}"
    `#{cmd}`
  end

  ## WRITE GIF FRAMES TO IMAGES FOLDER
  def create_frames(url)
    @gifm = MiniMagick::Image.open(url)
    @gifm.frames.each_with_index do |frame, idx|
      frame.write("images/frame#{idx}.jpg")
    end
    preview(url)
  end

  ## PREVIEW GIF IN TERMINAL
  def preview(url)
    puts "...in color? (yes/no)"
    answer = gets.chomp.downcase
    num_frames = @gifm.frames.count
    frames = num_frames.times.map {|f| "images/frame#{f}.jpg"}
  if answer == "yes"
    frames.cycle.first(num_frames * 2).each do |frame|
      a = AsciiArt.new(frame)
      puts "\e[H\e[2J"
      puts a.to_ascii_art(color: true,
                          width: 70)
      sleep 0.03
    end
  elsif answer == "no"
    frames.cycle.first(num_frames * 2).each do |frame|
      a = AsciiArt.new(frame)
      puts a.to_ascii_art
    end
  else
    preview(url)
  end
    delete_frames
    puts "\e[H\e[2J"
    browser_choice(url)
  end

  ## AFTER GIF PREVIEWED IN TERMINAL, DELETE GIF FRAME FILES
  def delete_frames
    FileUtils.rm_rf(Dir.glob('images/*'))
  end

  ## AFTER VIEWING IN TERMINAL, CHECK IF USER WANTS TO VIEW IN BROWSER
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
