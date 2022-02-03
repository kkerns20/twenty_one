# Assignment Twenty_One

## Task

Build a command line game called twenty_one that is similar to blackjack
    - Stripped down quite a bit
        - no splits
        - no double downs
        - etc...

## Rules

- Start with normal 52-card deck
    - 4 suits (hearts, diamonds, spades, clubs)
    - 13 cards in each suit (2-10, J, Q, K, A)
- Goal is try to get as close to 21 as possible, without going over
    - If you go over 21, it's a "bust" and you lose.

### Setup

- 2 players
    - `'Dealer'`
    - `'Player'`
- Both dealt two cards
    - `'Player'` can see both card
    - `'Dealer'` only shows one

### Card values

- 2-10 are face value (i.e. 3 = 3 points)
- J, Q, K are worth 10 points
- A are worth 1 or 11
- A value is determined by the program everytime a new card is drawn from the deck
    - If the hand contains a 2, an ace, and a 5, then the total value of the hand is 18. In this case, the ace is worth 11 because the sum of the hand (2 + 11 + 5) doesn't exceed 21.
    - If the hand's value exceeds 21 while the Ace is worth 11, then the Ace will be reappropiated to the value of 1
    - If another Ace is drawn, the program will account for the excessive value and it will be worth 1 point as well.

| Card    | Value      |
|---------|------------|
| 2 - 10  | face value |
| J, Q, K | 10         |
| A       | 1 or 11    |

### Player's Turn

- The Player goes first
- They may decide to `'hit'` or `'stay'`
- `'hit'` = player gets another card, and if total exceeds 21, then "bust" and loses
- `'stay'` = player stays with current hand total
- The decision is dependent upon what he thinks the dealer has
    -  For example, if the dealer is showing a "10" (the other card is hidden), and the player has a "2" and a "4", then the obvious choice is for the player to "hit".
- The player can `'hit'` as often as they would like
- Turn is over when player reaches 21, stays, or busts
- If player bust, game over and dealer wins.

### Dealer's Turn
- When player `'stays'` then its the dealer's turn
- Dealer flips over hidden card
- Dealer chooses to hit or stay based upon strict rule:
    - Dealer must always hit *unless* his hand total is 17 or more
- If dealer busts, then player wins

### Comparing card:

    - When both the player and the dealer stay, it's time to compare the total value of the cards and see who has the highest value.
