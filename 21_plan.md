# Twenty-One Plan

*This is my plan on how to write code for my version of 21. I intend on continuing to write simple methods that accomplish one of so things well and then bundle and bundle more so that the game play is simplified.*

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

- `hand_total

### Display Hands

### Calculate Hand Total

### Player's turn

### Dealer's turn

### Compare Hands

### Display Winner

### Play again?

### Dislay goodbye
