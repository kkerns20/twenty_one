WINNING_VALUE = 21
FORCE_DEALER_STAY = 17
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
  '*' => "*"
}
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
  thank_you: "Thank you for playing #{WINNING_VALUE}!",
  quote: "Don't cry because it's over, smile because it happened. - Dr. Seuss"
  continue: "Press Enter to continue.",
  title: "You are playing #{WINNING_VALUE}.",
  player_turn: "It's your turn.",
  players_hand: "Your hand:",
  player_action: "Hit or Stay? (h/hit or s/stay)",
  player_busted: "You busted!",
  player_won: "You won!",
  dealer_hand: "Dealer's Hand:"
  dealer_turn: "It's the dealer's turn.",
  dealer_stay: "Dealer chose to stay.",
  dealer_hit: "Dealer chose to hit.",
  dealer_busted: "Dealer busted!",
  dealer_won: "Dealer won!",
  tie: "It's a tie.",
  game_over: "Game over.",
  play_again: "Want to play again? (y/yes or n/no)",
  invalid_input: "Please enter a valid input.",
  separator_line: '-' * 80
}
YES_OR_NO = %w(y n yes no)

def initialize_cards
  {
    deck: initialize_deck,
    player: [],
    dealer: [],
  }
end

def initialize_totals
  {
    player: 0,
    computer: 0,
  }
end

def initialize_deck
  SUITS.product(RANKS).shuffle
end

def deal_cards(cards)
  2.times do
    deal_card!(:player, cards, totals)
    deal_card!(:dealer, cards, totals)
  end
end

def deal_card!(player, cards, totals)
  cards[player] = cards[:deck].pop
  totals[player] = total(cards[player])
end

def hand_total(cards)
  sum = cards.reduce(0) { |sum, card| sum + value[card[1]] }
  
  if cards.count { |_, rank| rank == 'A' }
    .times { sum += 10 if sum += 10 <= WINNING_VALUE }
    sum
  end
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
  prompt_pause(:continue)
  gets
end

def display_goodbye
  prompt_pause(:thank_you)
  prompt_pause(:quote)
end

def display_hands(cards, totals, hide_dealer_card: false)
  clear_screen
  
  prompt_pause(:title) 
  prompt_pause(:players_hand)
  display_cards(cards[:player, totals[:player]])
  
  prompt_pause(:dealer_hand)
  if hide_dealer_card
    display_cards([cards[:dealer][0], ['*', '*']])
  else
    display_cards(cards[:dealer], totals[:dealer])
  end
end

def display_cards(cards, total = nil)
  puts
  puts cards_top(cards)
  puts middle_of_card(cards)
  puts bottom_of_card(cards)
  puts
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
    str + (card[1] == '10' ? "|#{card[1]}  | " : "| #{card[1]} | " )
  end
end

def display_end_of_game(totals)
  result = evaluate_result(totals)
  display_totals(totals) if [:player_won, :dealer_won, :tie].include?(result)
  display_result(result)
end

def display_totals(totals)
  sleep(SLEEP_DURATION)
  puts MESSAGES(:separator_line)
  prompt "The dealer's hand's final total is #{totals[:dealer]}."
  prompt "Your hand's final total is #{totals[:player]}."
  puts MESSAGES(:separator_line)
end

def evaluate_result(totals)
  player_total = totals(:player)
  dealer_total = totals(:dealer)
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

# Player Action
def player_turn(cards, totals)
  prompt_pause(:player_turn)
  action = nil
  loop do
    action = get_player_action
    deal_card!(:player, cards, totals) if action == :hit
    display_state(cards, totals, hide_dealer_card: true)
    break if action == :stay || bust?(totals[:player])
  end
end

def get_player_action
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
def dealer_turn(cards, totals)
  prompt_pause():dealer_turn)
  loop do
    display_state(cards, totals)
    sleep(SLEEP_DURATION)

    if bust?(totals[:dealer])
      break
    elsif dealer_stay?(totals[:dealer])
      prompt MESSAGES[:dealer_stay]
      break
    end

    deal_card!(:dealer, cards, totals)
  end
end

# Auxillary methods
def prompt_pause(action)
  puts ">> #{MESSAGES[action]}"
  sleep(1.5)
end

def prompt(msg, new_line = false)
  puts ">> #{msg}"
  puts if new_line
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

  answer == 'y' || answer == 'yes' ? 'y' : 'n'
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

def play_twenty_one
  display_welcome
  loop do
    play_match
    break unless play_again?
  end
  display_goodbye
end

def play_match
  cards = initialize_cards
  totals = initialize_totals
  deal_cards(cards, totals)
  display_state(cards, totals, hide_dealer_card: true)
  player_turn(cards, totals)
  dealer_turn(cards, totals) unless bust?(totals[:player])
  display_end_of_game(totals)
end

play_twenty_one
