# Twenty One

require 'pry-byebug'

# CONSTANTS
# ============================================================================

WINNING_VALUE = 21
FORCE_DEALER_STAY = 17
TOURNEY_WINNER = 5

PLAYER = 'Player'
HOUSE = 'House'

SUITS = %w(S H D C)
NUMBERED_RANKS = (2..10).map(&:to_s)
ROYAL_RANKS = %w(J Q K)
ACE = 'A'
RANKS = NUMBERED_RANKS + ROYAL_RANKS + [ACE]
SUIT_SYMBOLS = {
  'S' => "\u2660",
  'H' => "\u2665",
  'D' => "\u2666",
  'C' => "\u2663",
  '*' => '*'
}

SLEEP_DURATION = 1.5
YES_OR_NO = %w(y n yes no)

MESSAGES = {
  welcome: "Welcome to #{WINNING_VALUE}!",
  rules: <<~RULES,
    Rules of the Game:
    - You are playing a tournament against the House, \
    who employs a dealer.
    - You and the dealer will each be dealt 2 cards.
    - You play first, and then the dealer will play.
    - You can choose to hit (draw) or stay (don't draw).
  RULES
  info: <<~INFO,
    Gameplay information:
    - The hand value is the sum of all card values. Aces can be worth 1 or 11. 
    - A player busts and loses the game if their hand value exceeds 21.
    - The greater hand value wins if neither player busts.
    - Tourney is first to 5 wins.
  INFO
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
  player_won: 'You won!',
  dealer_hand: "Dealer's Hand:",
  dealer_stay: 'Dealer must stay.',
  dealer_busted: 'Dealer busted, so you win!',
  dealer_won: "Dealer won, so the #{HOUSE} won!",
  house_victory: "The #{HOUSE} appreciates you playing and, \
    of course, your money!",
  player_victory: 'You ought to try your luck at Vegas! Congrats on winning!',
  tie: "It's a tie.",
  tourney_over: 'Tourney over.',
  play_again: 'Want to play again? (y/yes or n/no)',
  invalid_input: 'Please enter a valid input.',
  separator_line: '-' * 70
}

# Initialization
def initialize_cards
  { deck: initialize_deck }
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
  loop do
    display_hands(game_data)
    sleep(SLEEP_DURATION)

    if bust?(game_data[:dealer][:total])
      break
    elsif dealer_stay?(game_data[:dealer][:total])
      prompt_pause(:dealer_stay)
      break
    end

    deal_card!(:dealer, cards, game_data)
  end
end

# Dealing Cards

def deal_player_in(cards, game_data)
  2.times do
    deal_card!(:player, cards, game_data)
    deal_card!(:dealer, cards, game_data)
  end
end

def deal_card!(player, cards, game_data)
  game_data[player][:hand] << cards[:deck].pop
  game_data[player][:total] = hand_total(game_data[player][:hand])
end

# Hand Calculation

def hand_total(hand)
  sum = hand.reduce(0) do |accumulation, card|
    accumulation + value(card[1])
  end

  hand.count { |_, rank| rank == 'A' }
      .times { sum += 10 if sum + 10 <= WINNING_VALUE }

  sum
end

def value(rank)
  if NUMBERED_RANKS.include?(rank)
    rank.to_i
  elsif ROYAL_RANKS.include?(rank)
    10
  elsif rank == ACE
    1
  end
end

# Display

def display_welcome
  clear_screen
  prompt_pause(:welcome)
  prompt_pause(:rules)
  display_empty_line
  prompt_pause(:info)
  continue
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

# rubocop:disable Metrics/AbcSize
def display_hands(game_data, hide_dealer_card: false)
  clear_screen

  prompt MESSAGES[:title]
  puts <<~MSG
    -------------------------------------
    SCOREBOARD: #{PLAYER}: [#{game_data[:player][:score]}] #{HOUSE}: [#{game_data[:dealer][:score]}]
    -------------------------------------
  MSG

  prompt MESSAGES[:players_hand]
  display_cards(game_data[:player][:hand], game_data[:player][:total])

  prompt MESSAGES[:dealer_hand]
  if hide_dealer_card
    display_cards([game_data[:dealer][:hand][0], ['*', '*']])
  else
    display_cards(game_data[:dealer][:hand], game_data[:dealer][:total])
  end
end
# rubocop:enable Metrics/AbcSize

def display_cards(cards, total = nil)
  display_empty_line
  puts top_of_card(cards)
  puts middle_of_card(cards)
  puts bottom_of_card(cards)
  display_empty_line
  prompt("Hand Total: #{total}") if total
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

# Results

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

# Scoreboard and winning

def increase_score!(game_data, winner)
  if winner == :player_busted || winner == :dealer_won
    game_data[:dealer][:score] += 1
  elsif winner == :dealer_busted || winner == :player_won
    game_data[:player][:score] += 1
  end
end

def game_over(game_data, winner)
  display_winner(game_data, winner)
  increase_score!(game_data, winner)
  continue
end

def display_winner(game_data, winner)
  unless winner == :player_busted ||
         winner == :dealer_busted
    display_hands(game_data, hide_dealer_card: false)
  end
  display_end_of_game(game_data)
end

def display_tourney_winner(game_data)
  prompt_pause(:tourney_over)
  if game_data[:player][:score] >= TOURNEY_WINNER
    prompt_pause(:player_victory)
  elsif game_data[:dealer][:score] >= TOURNEY_WINNER
    prompt_pause(:house_victory)
  end
end

# Auxillary methods

def prompt_pause(action)
  puts ">> #{MESSAGES[action]}"
  sleep(SLEEP_DURATION)
end

def prompt(msg)
  puts ">> #{msg}"
end

def clear_screen
  system 'clear'
end

def continue
  prompt_pause(:continue)
  gets
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
  total >= FORCE_DEALER_STAY &&
    total <= WINNING_VALUE
end

def play_again?
  sleep(SLEEP_DURATION)
  prompt MESSAGES[:play_again]
  answer = valid_input

  answer.start_with?('y')
end

# PLAY TWENTY ONE
# ============================================================================

def play_single_round(game_data, cards)
  display_hands(game_data, hide_dealer_card: true)

  player_turn(cards, game_data)
  dealer_turn(cards, game_data) unless bust?(game_data[:player][:total])
end

def fresh_hand(game_data)
  game_data[:player][:hand] = []
  game_data[:dealer][:hand] = []
end

# Game loop

display_welcome

loop do
  game_data = initialize_game_data
  loop do
    fresh_hand(game_data)
    cards = initialize_cards
    display_shuffling
    deal_player_in(cards, game_data)

    play_single_round(game_data, cards)

    winner = evaluate_result(game_data)
    game_over(game_data, winner)
    break if game_data.values.any? { |val| val[:score] >= TOURNEY_WINNER }
  end

  display_tourney_winner(game_data)

  break unless play_again?
end

quit_game
