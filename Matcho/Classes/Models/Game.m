//
//  Game.m
//  Matcho
//
//  Created by Anton Lookin on 10/27/15.
//  Copyright © 2015 geekub. All rights reserved.
//

#import "Game.h"

@interface Game ()


@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSString *gameLog;
@property (nonatomic) BOOL gameOver;


@end


@implementation Game



- (instancetype)initWithCardCount:(NSUInteger)count
						usingDeck:(Deck *)deck {
	self = [super init];
	
	if (self) {
        
        Card *joker = [[Card alloc] init];
            joker.contents = @"Joker";
            [self.cards addObject: joker];
            count--;
       
        
		for (NSUInteger i = 0; i < count; i++) {
           
            
			Card *card = [deck drawRandomCard];
			
			if (card) {
				[self.cards addObject:card];
			} else {
				self = nil;
				break;
			}
		}
	}
	return self;
}

-(BOOL)gameEnd{
    return _gameOver;
}

-(NSString *)gameLog{
    return _gameLog;
}


- (NSMutableArray *)cards {
	if (!_cards) _cards = [[NSMutableArray alloc] init];
	return _cards;
}


static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (void)chooseCardAtIndex:(NSUInteger)index {
	Card *card = [self cardAtIndex:index];
    if ([self haveIsMatchedCard]){
        if (!card.isMatched) {
            if (card.isChosen) {
                card.chosen = NO;
                self.gameLog = [NSString stringWithFormat:@"Close card %@, the score remained unchanged",card];
            }
            else {
                NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        [chosenCards addObject:otherCard];
                    }
                }
            
                if ([chosenCards count]) {
                    int matchScore = [card match:chosenCards];
                    if (matchScore) {
                        self.score += (matchScore * MATCH_BONUS);
                    
                        card.chosen = YES;
                        card.matched = YES;
                        for (Card *otherCard in chosenCards) {
                            otherCard.matched = YES;
                            self.gameLog = [NSString stringWithFormat:@"Cards %@ and %@ are match, you got %i points",card, otherCard, (matchScore * MATCH_BONUS)];
                        }
                    }
                    else {
                        int penalty = MISMATCH_PENALTY;
                    
                        self.score -= penalty;
                    
                        card.chosen = YES;
                        for (Card *otherCard in chosenCards) {
                            otherCard.chosen = NO;
                            self.gameLog = [NSString stringWithFormat:@"Cards %@ and %@ are do not match, you lose %i points", card, otherCard, COST_TO_CHOOSE];
                        }
                    }
                }
                else {
                    self.score -= COST_TO_CHOOSE;
                    card.chosen = YES;
                    self.gameLog = [NSString stringWithFormat:@"You opened the card %@, you lose %i points",card, COST_TO_CHOOSE];
                }
            }
        }
    }
    else{
        self.gameLog = @"No more card";
    }
}


- (Card *)cardAtIndex:(NSUInteger)index {
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (BOOL)haveIsMatchedCard{
    for (Card *card in self.cards){
        if(!card.matched){
            for(Card *secondCard in self.cards){
                if(card != secondCard && !secondCard.matched){
                    if ([card match:@[secondCard]]) {
                        return YES;
                    }
                }
            }
        }
    }
    _gameOver = YES;
    return NO;
}

-(void)gameLogSendMassage:(NSString *)massage{
    self.gameLog = massage;
}


@end
