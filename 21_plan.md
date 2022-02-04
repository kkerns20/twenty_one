# Twenty-One Plan

*This is my plan on how to write code for my version of 21. I intend on continuing to write simple methods that accomplish one of so things well and then bundle and bundle more so that the game play is simplified.*

[Implementation Steps](#implementation-steps)
[Main Processes](#main-processes)
    [Play Twenty One](#play_twenty_one)
    [Play Match](#play_match)
[Subprocesses](#subprocesses)
    [Initialization](#initialization)
    [Deal Cards](#deal-cards)
    [Displays](#displays)
    [Player's Turn](#players_turn)
    [Dealer's Turn](#dealers_turn)
[Auxillary Methods](#auxillary-methods)

## Examples of Gameplay

### 1.

```
Dealer has: Ace and unknown card
You have: 2 and 8
```
You should "hit" in this scenario. You see the dealer has an "Ace", which means the dealer has a high probability of having a 21, the optimal number. On top of that, your total of 10 can only benefit from an extra card, as there's no way you can bust.

### 2.

```
Dealer has: 7 and unknown card
You have: 10 and 7
```
You should "stay" here, because chances are good that the unknown card is not an Ace, which is the only situation where you can lose. Most likely, you're going to win with 17, or tie. There's a very small chance you will lose.

### 3.

```
Dealer has: 5 and unknown card
You have: Jack and 6
```
This one is a little tricky, and at first glance, you may think that either a "hit" or "stay" would be appropriate. You have 16 and you could maybe try to get lucky and land a card less than 6. That would be ok reasoning, except for the fact that the dealer has a 5. You're anticipating that the unknown card is worth 10, thereby making the dealer's cards worth 15. This means the dealer must hit, and there's a good chance the dealer will bust. The best move here is to "stay", and hope the dealer busts.

## Implementation Steps

1. Initialize deck
2. Deal cards to player and dealer
3. Player turn: hit or stay
  - repeat until bust or "stay"
4. If player bust, dealer wins.
5. Dealer turn: hit or stay
  - repeat until total >= 17
6. If dealer bust, player wins.
7. Compare cards and declare winner.

## Constants

- WINNING_VALUE = 21
- FORCE_DEALER_STAY = 17

- SUITS = %w(S H D C)
- NUMBERED_RANKS = (2..10).map(&:to_s)
- ROYAL_RANKS = %w(J Q K)
- ACE = 'A'
- RANKS = NUMBERED_RANKS + ROYAL_RANKS + [ACE]
- SUIT_SYMBOLS = {
    'S' => "\u2660",
    'H' => "\u2665",
    'D' => "\u2666",
    'C' => "\u2663",
    '*' => "*"
  }
- MESSAGES = {
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

## Main processes

### play_twenty_one

- `display_welcome`
- main loop
    - `play_match`
    - break unless `play_again?`
- `display_goodbye`

### play_match

- local variable `cards` set to `initialize_cards`
- local variable `totals` set to `initialize_totals`
- `deal_cards`
    -  `calculate_totals`
- `display_hands`
- `player_turn`
- `dealer_turn`
- `display_match_end

## Subprocesses

### Initialization

- `initialize_cards`
    - create a hash
        - deck key
            - all cards available for deal
        - player key
            - store cards dealt to player
        - dealer key
            - store cards dealt to dealer

- `initialize_totals`
    - create hash
        - keys: player and dealer
        - values: 0

- `initialize_deck`
    - create constants for suits and ranks (2-10 + royals + ace)
    - array#product for nested array of cards
    - shuffle array like shuffling deck

### Deal Cards

- `deal_cards`
    - 2 `times` deal:
        - player
        - dealer
- `deal_card!`
    - `pop` from `cards[:deck]` to `cards[:player]`
    - use method `total` to calculate value of hand for each player
        - set to `totals[:player]`

#### Calculate Hands

- `hand_total`
    - set local variable to method as `sum`
    - use Enumerable#reduce with the `value(card[1])`
    - also, `count` Aces
    - each `times` and Ace appears, add 10 if sum +10 is less than 21
- `value`
    - conditional if numbered, change it `.to_i`
    - elsif royal, change to 10
    - elsif `rank` == `ACE`, change it to 1

### Displays

#### display_welcome

- welcome the user
- go over rules
- explain ranks
- explain ace
- explain 'hit' and 'stay'
- explain 'bust'
- add `ready_to_play` method that accepts enter
- add `display_loading_animation`

#### display_cards

- `top_of_card`
    - `reduce('')` and add `"|#{SUIT_SYMBOLS[card[0]]}  |"
- `bottom of card
    - `reduce('')` and add `"|  #{SUIT_SYMBOLS[card[0]]}|"
- `middle_of_card`
    - `reduce('')` with ternary for double digit 10
        - to add `"|#{SUIT_SYMBOLS[card[1]]}  |"
        - or add `"| #{SUIT_SYMBOLS[card[1]]} |"

#### display_hands

- `empty_line`
- `top_of_card(cards)`
- `middle_of_card(cards)`
- `bottom_of_card(cards)`
- `empty_line`
- `display hand total`

#### display_state

- `clear_screen`
- display title
- prompt your_hand
- display_hands
- prompt dealer's cards
    - conditional for hidden card set true in display_state

#### display_totals

- sleep
- empty line or separator
- the dealer's final total is
- Your hands' is
- empty line or separator

#### display_results

- first, we must `evaluate_results`
    - set local vars for `player_total` and `dealer_total`
    - conditional
        - first check player bust
        - dealer bust
        - player > dealer
        - dealer > player
        - else tie
- display result

#### display_goodbye

- display goodby message

### players_turn

- prompt player's turn
    - hit or stay
- set local var `action`
- enter loop
    - validate hit or stay with `get_player_action`
        - have player_action MESSAGE
        - validate with array of choices `%w(h hit s stay)`
        - return `:hit` or `:stay` with ternary from `answer.start_with?`
    - `deal_card!` if action == :hit
    - display_state with hidden dealer card
    end loop

### dealers_turn

- prompt dealer's turn
- enter loop
    - `display_state`
    - sleep
    - conditional for `bust?`
    - `stay?`
    - then `deal_card!`

## Auxillary methods

- `prompt`
- `prompt_pause`
- `bust?`
- `dealer_stay?`
- `play_again?` <!-- pull from ttt -->

