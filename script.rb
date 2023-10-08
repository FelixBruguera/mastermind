require "colorize"
class Game
  attr_reader :code
  attr_accessor :user_guess, :check, :turns, :result
  @@code = []
  @@user_guess = []
  @@check = false
  @@turns = 1
  @@result = []
  def check_guess(guess)
    correct = 0
    wrong_pos = 0
    if guess == @@code then @@check = true end
    guess.each_with_index do |num,ind|
      if guess[ind] == @@code[ind] then correct +=1
      elsif @@code.include?(guess[ind]) && guess[ind] != @@code[ind] then wrong_pos += 1
      end
  end
    puts "#{correct} correct, #{wrong_pos} in the wrong position"
    @@result = [correct,wrong_pos]
  end
  def play(user_sets)
    user_sets = user_sets.upcase.chomp
    if user_sets == "N"
      setter = Computer.new()
      setter.random_code()
      guesser = User.new()
      puts "Enter 4 numbers between 1 and 6, separated by a comma"
      puts "You have 8 turns to guess the code"
    else
      puts "Enter 4 numbers between 1 and 6, separated by a comma"
      setter = User.new()
      user_code = setter.set_code()
      if user_code == "Wrong input" then return puts "Wrong input" end
      guesser = Computer.new()
    end
    while @@check == false && @@turns <= 8
      if @@turns > 1 && user_sets == "Y" then puts "Computer guess: #{@@user_guess.to_a}" end
      puts "Turn #{@@turns}".underline
      guesser.get_guess()
      self.check_guess(@@user_guess)
      @@turns += 1
      if user_sets == "Y" then guesser.update_set(@@user_guess,@@result) end
    end
    if @@check == true && user_sets == "N"
      return puts "You win!"
    elsif @@check == true && user_sets == "Y"
      return puts "You lose, the computer guessed your code"
    end
    if @@turns > 7 && user_sets == "N"
      return puts "You lose, the code was #{@@code}"
    elsif @@turns > 7 && user_sets == "Y"
      return puts "You win! the computer didn't guess your code"
    end
  end
end

class Computer < Game
  attr_accessor :set
  def initialize
    @@set = [[1,1,2,2]]
    while @@set.length < 1296
      code_set = []
      4.times do
        code_set.push(rand(1..6))
      end
      if @@set.include?(code_set) then next
      else @@set.push(code_set)
      end
    end
  end
  def random_code
    4.times do
      @@code.push(rand(1..6))
    end
  end
  def get_guess
    @@user_guess = @@set[0]
  end
  def update_set(guess,result)
    filtered = []
    for i in @@set do
      correct = 0
      wrong_pos = 0
      i.each_index do |ind|
        if i[ind] == guess[ind] then correct +=1
        elsif i.include?(guess[ind]) && i[ind] != guess[ind] then wrong_pos += 1
      end
        if correct == result[0].to_i && wrong_pos == result[1].to_i then filtered.push(i) 
        else next
        end
    end
  end
    filtered.delete(guess)
    @@set = filtered
  end
end
  
class User < Game
  def get_guess()
    guess = gets
    guess = guess.chomp.split(",")
    guess = guess.map {|num| num.to_i}
    if guess.length != 4 then return "Wrong input" end
    guess.each do |num|
      if (1..6).include?(num) then next else return puts "Wrong input" end
    end
    @@user_guess = guess
  end
  def set_code()
    user_input = gets
    user_input = user_input.split(",").map {|num| num.chomp.to_i}
    if user_input.length != 4 then return "Wrong input" end
    user_input.each do |num|
      if (1..6).include?(num) then next else return puts "Wrong input" end
    end
    user_input.each {|num| @@code.push(num)}
  end
end

mastermind = Game.new()
puts "Do you want to set the code? (Y/N)"
prompt = gets
mastermind.play(prompt)