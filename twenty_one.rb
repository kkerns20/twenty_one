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
  welcome: "Welcome to Twenty-One!",
  rules: <<~MSG,
    Rules of the Game:
    - You and the dealer will each be dealt 2 cards.
    - You play first, and then the dealer will play.
    - You can choose to hit (draw) or stay (don't draw).
    - The hand value is the sum of all card values. Aces can be worth 1 or 11. 
    - A player busts and loses the game if their hand value exceeds 21.
    - The greater hand value wins if neither player busts.
  MSG
  goodbye: "Thank you for playing Twenty-One. Goodbye!",
  continue: "Press Enter to continue.",
  player_turn: "It's your turn.",
  query_player_action: "Hit or Stay? (h/hit or s/stay)",
  player_busted: "You busted!",
  player_won: "You won!",
  dealer_turn: "It's the dealer's turn.",
  dealer_stay: "Dealer chose to stay.",
  dealer_hit: "Dealer chose to hit.",
  dealer_busted: "Dealer busted!",
  dealer_won: "Dealer won!",
  tie: "It's a tie.",
  game_over: "Game over.",
  final_hands: "Final hands:",
  play_again: "Want to play again? (y/yes or n/no)",
  invalid_input: "Please enter a valid input.",
  separator_line: '-' * 80
}

def prompt_pause(action)
  puts ">> #{MESSAGES[action]}"
  sleep(1.5)
end

def prompt(msg)
  puts ">> #{msg}"
end

def clear_screen
  system 'clear'
end

def valid_input
  answer = nil

  loop do
    answer = gets.chomp.downcase.strip
    break if YES_OR_NO.include?(answer)
    prompt_pause(:invalid)
  end

  answer == 'y' || answer == 'yes' ? 'y' : 'n'
end
  
def quit_game
  display_goodbye
  exit
end

def display_welcome
  clear_screen
  prompt_pause(:welcome)
  prompt_pause(:rules)
  prompt_pause(:continue)
  gets
end

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
  
end