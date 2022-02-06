# twenty_one.rb

require 'pry-byebug'

WINNING_VALUE = 21
FORCE_DEALER_STAY = 17
TOURNEY_WINNER = 5
PLAYER = 'Player'.freeze
HOUSE = 'House'.freeze

SUITS = %w(S H D C).freeze
NUMBERED_RANKS = (2..10).map(&:to_s)
ROYAL_RANKS = %w(J Q K).freeze
ACE = 'A'.freeze
RANKS = NUMBERED_RANKS + ROYAL_RANKS + [ACE]
SUIT_SYMBOLS = {
  'S' => "\u2660",
  'H' => "\u2665",
  'D' => "\u2666",
  'C' => "\u2663",
  '*' => '*'
}.freeze
SLEEP_DURATION = 1.5

MESSAGES = {
  welcome: "Welcome to #{WINNING_VALUE}!",
  rules: <<~MSG,
    Rules of the Game:
    - You and the dealer will each be dealt 2 cards.
    - You play first, and then the dealer will play.
    - You can choose to hit (draw) or stay (don't draw).
    - The hand value is the sum of all card values. Aces can be worth 1 or 11. 
    - A player busts and loses the game if their hand value exceeds 21.
    - The greater hand value wins if neither player busts.
  MSG
  shuffling: 'Shuffling the deck!',
  thank_you: "Thank you for playing #{WINNING_VALUE}!",
  quote: "Don't cry because it's over, smile because it happened. \n
  - Dr. Seuss",
  continue: 'Press Enter to continue.',
  title: "You are playing #{WINNING_VALUE}.",
  player_turn: "It's your turn.",
  players_hand: 'Your Hand:',
  player_action: 'Hit or Stay? (h/hit or s/stay)',
  player_busted: "You busted, so the #{HOUSE} wins!",
  dealer_check_natural: 
    "The dealer is checking for a natural #{WINNING_VALUE}...",
  dealer_natural_yes: "The dealer has a natural #{WINNING_VALUE}!",
  dealer_natural_no: "The dealer doesn't have a natural #{WINNING_VALUE}.",
  player_won: 'You won!',
  dealer_hand: "Dealer's Hand:",
  dealer_turn: "It's the dealer's turn.",
  dealer_stay: 'Dealer must stay.',
  dealer_hit: 'Dealer must hit.',
  dealer_busted: 'Dealer busted, so you win!',
  dealer_won: "Dealer won, so the #{HOUSE} won!",
  house_won: "The #{HOUSE} appreciates you playing, and your money!",
  player_victory: 'You ought to try your luck at Vegas! Congrats on winning!',
  tie: "It's a tie.",
  tie_no_score: 'Due to the tie, score remains the same for the tourney...',
  game_over: 'Game over.',
  play_again: 'Want to play again? (y/yes or n/no)',
  invalid_input: 'Please enter a valid input.',
  separator_line: '-' * 50
}.freeze
YES_OR_NO = %w(y n yes no).freeze

def initialize_cards
  { deck: initialize_deck}
end

def initialize_game_data
  {
    player: { hand: [],
              total: nil,
              score: 0 },
    dealer: { hand: [],
              total: nil,
              score: 0 }
  }
end

def initialize_deck
  SUITS.product(RANKS).shuffle
end

# Player Action
def player_turn(cards, game_data)
  prompt MESSAGES[:player_turn]
  action = nil
  loop do
    action = query_player_action
    deal_card!(:player, cards, game_data) if action == :hit
    display_hands(game_data, hide_dealer_card: true)
    break if action == :stay || bust?(game_data[:player][:total])
  end
end

def query_player_action
  answer = ''
  loop do
    prompt MESSAGES[:player_action]
    answer = gets.chomp.downcase
    break if %w(h hit s stay).include?(answer)

    prompt MESSAGES[:invalid_input]
  end

  answer.start_with?('h') ? :hit : :stay
end

# Dealer Action
def dealer_turn(cards, game_data)
  prompt MESSAGES[:dealer_turn]
  loop do
    display_hands(game_data)
    sleep(SLEEP_DURATION)
    if bust?(game_data[:dealer][:total])
      break
    elsif dealer_stay?(game_data[:dealer][:total])
      prompt MESSAGES[:dealer_stay]
      break
    end
    # binding.pry
    prompt MESSAGES[:dealer_hit]
    deal_card!(:dealer, cards, game_data)
  end
end

def deal_cards(cards, game_data)
  2.times do
    deal_card!(:player, cards, game_data)
    deal_card!(:dealer, cards, game_data)
  end
end

def deal_card!(player, cards, game_data)
  game_data[player][:hand] << cards[:deck].pop
  game_data[player][:total] = hand_total(game_data[player][:hand])
end

def hand_total(hand)
  sum = hand.reduce(0) do |sum, card| 
          sum + value(card[1]) 
        end

  hand.count { |_, rank| rank == 'A' }
       .times { sum += 10 if sum + 10 <= WINNING_VALUE }

  sum
end

def value(rank)
  if NUMBERED_RANKS.include?(rank)
    return rank.to_i
  elsif ROYAL_RANKS.include?(rank)
    return 10
  elsif rank == ACE
    return 1
  end
end

def dealer_check_natural(game_data)
  prompt_pause(:dealer_check_natural)
  display_loading_animation
  if game_data[:dealer][:total] == WINNING_VALUE
    prompt MESSAGES[:dealer_natural_yes]
    prompt MESSAGES[:dealer_won]
    return 21
  else
    prompt MESSAGES[:dealer_natural_no]
  end
end

def check_natural(game_data)
  if game_data[:player][:total] == WINNING_VALUE &&
     game_data[:dealer][:total] == WINNING_VALUE
    prompt MESSAGES[:natural_push]
    return :tie
  elsif game_data[:dealer][:total] == WINNING_VALUE
    :dealer_won
  elsif game_data[:player][:total] == WINNING_VALUE
    :player_won
  end
  nil
end

def natural_win(game_data)
  unless WINNING_VALUE > 21
    if value(game_data[:dealer][:hand][0][1]) == 10 ||
       value(game_data[:dealer][:hand][0][1]) == 1
      dealer_check_natural(game_data)
    end
  end
end

# Display
def display_welcome
  clear_screen
  # prompt_pause(:welcome)
  # prompt_pause(:rules)
  prompt_pause(:continue)
  gets
end

def display_goodbye
  prompt_pause(:thank_you)
  prompt_pause(:quote)
end

def display_empty_line
  puts ''
end

def display_loading_animation
  3.times do
    print ". "
    sleep 0.5
  end
  display_empty_line
end

def display_shuffling
  prompt MESSAGES[:shuffling]
  display_loading_animation
end

def display_hands(game_data, hide_dealer_card: false)
  clear_screen

  prompt(MESSAGES[:title], true)
  prompt MESSAGES[:players_hand]
  display_cards(game_data[:player][:hand], game_data[:player][:total])

  prompt MESSAGES[:dealer_hand]
  if hide_dealer_card
    display_cards([game_data[:dealer][:hand][0], ['*', '*']])
  else
    display_cards(game_data[:dealer][:hand], game_data[:dealer][:total])
  end
end

def display_cards(cards, total = nil)
  display_empty_line
  puts top_of_card(cards)
  puts middle_of_card(cards)
  puts bottom_of_card(cards)
  display_empty_line
  prompt("Hand Total: #{total}", new_line: true) if total
end

def top_of_card(cards)
  cards.reduce('') { |str, card| str + "|#{SUIT_SYMBOLS[card[0]]}  | " }
end

def bottom_of_card(cards)
  cards.reduce('') { |str, card| str + "|  #{SUIT_SYMBOLS[card[0]]}| " }
end

def middle_of_card(cards)
  cards.reduce('') do |str, card|
    str + (card[1] == '10' ? "|#{card[1]} | " : "| #{card[1]} | ")
  end
end

def display_end_of_game(game_data)
  result = evaluate_result(game_data)
  display_totals(game_data) if %i(player_won dealer_won tie).include?(result)
  display_result(result)
end

def display_totals(game_data)
  sleep(SLEEP_DURATION)
  puts MESSAGES[:separator_line]
  prompt "The dealer's hand's final total is #{game_data[:dealer][:total]}."
  prompt "Your hand's final total is #{game_data[:player][:total]}."
  puts MESSAGES[:separator_line]
end

def evaluate_result(game_data)
  player_total = game_data[:player][:total]
  dealer_total = game_data[:dealer][:total]
  if bust?(player_total)
    :player_busted
  elsif bust?(dealer_total)
    :dealer_busted
  elsif player_total > dealer_total
    :player_won
  elsif player_total < dealer_total
    :dealer_won
  else
    :tie
  end
end

def display_result(result)
  prompt_pause(result)
end

# Auxillary methods
def prompt_pause(action)
  puts ">> #{MESSAGES[action]}"
  sleep(SLEEP_DURATION)
end

def prompt(msg, new_line = false)
  puts ">> #{msg}"
  display_empty_line if new_line
end

def clear_screen
  system 'clear'
end

def valid_input
  answer = nil

  loop do
    answer = gets.chomp.downcase.strip
    break if YES_OR_NO.include?(answer)

    prompt_pause(:invalid_input)
  end

  %w(y yes).include?(answer) ? 'y' : 'n'
end

def quit_game
  display_goodbye
  exit
end

def bust?(total)
  total > WINNING_VALUE
end

def dealer_stay?(total)
  total >= FORCE_DEALER_STAY
end

def play_again?
  sleep(SLEEP_DURATION)
  prompt MESSAGES[:play_again]
  answer = valid_input

  answer.start_with?('y')
end

display_welcome


loop do
  game_data = initialize_game_data
  cards = initialize_cards
  display_shuffling
  deal_cards(cards, game_data)
  display_hands(game_data, hide_dealer_card: true)
  break if natural_win(game_data)
  hand_result = check_natural(game_data)
  if hand_result.nil?
    player_turn(cards, game_data)
    dealer_turn(cards, game_data) unless bust?(game_data[:player][:total])
  end
  display_end_of_game(game_data)
  break unless play_again?
end

display_goodbye