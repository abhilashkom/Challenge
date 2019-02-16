## Credit card validator
import re

def valid(cards):
    Validpattern = r'^[0-9]{4}[-][0-9]{4}[-][0-9]{4}[-][0-9]{4}'
    for card in cards:
        if sum(x.isdigit() for x in card) != 16:
            print('Invalid Card')
            continue
        if card[0] not in ['4','5','6']:
            print('Invalid Card')
            continue
        if any(x not in set(str(_) for _ in range(10))|{'-'} for x in card):
            print('Invalid Card')
            continue
        card_split = card.split('-')
        if '-' in card and any(len(sub_card) != 4 for sub_card in card_split):
            print('Invalid Card')
            continue
        repeats = 1
        card = ''.join(s for s in card_split)
        for x in range(len(card) - 1):
            if card[x] == card[x + 1]:
                repeats += 1
            else:
                repeats = 1
            if repeats > 3:
                print('Invalid Card')
                break
        else:
            print('valid Card')
