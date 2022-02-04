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


def initialize_cards
  {
    deck: initialize_deck,
    player: [],
    dealer: []
  }
end

def initialize_totals
  {
    player: 0,
    dealer: 0
  }
end

def initialize_deck
  SUITS.product(RANKS).shuffle
end

def deal_cards(cards, totals)
  2.times do
    deal_card!(:player, cards, totals)
    deal_card!(:dealer, cards, totals)
  end
end

def deal_card!(player, cards, totals)
  cards[player] << cards[:deck].pop
  totals[player] = total(cards[player])
end

def total(cards)
  sum = cards.reduce(0) { |acc, card| acc + value(card[1]) }
  # Adjust upward for aces as able
  cards.count { |_, rank| rank == 'A' }
       .times { sum += 10 if sum + 10 <= GAME_NUMBER }
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

cards = initialize_cards

p cards

p cards.reduce(0) { |acc, card| acc + value(card[1]) }