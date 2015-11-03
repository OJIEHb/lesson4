//
//  GameOnThreeCard.m
//  Matcho
//
//  Created by Andrew Heiko on 02.11.15.
//  Copyright © 2015 geekub. All rights reserved.
//

#import "GameOnThreeCard.h"

@interface GameOnThreeCard()

@end

@implementation GameOnThreeCard

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;




-(void)chooseCardAtIndex:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    if([self haveIsMatchedCard]){
        if(!card.isMatched){
            if(card.isChosen){
                card.chosen = NO;
                [self gameLogSendMassage:[NSString stringWithFormat:@"Close card %@, the score remained unchanged",card]];
            }
            else{
                NSMutableArray *chosenCards = [[NSMutableArray alloc]init];
                for(Card *otherCard in self.cards){
                    if(otherCard.isChosen && !otherCard.isMatched){
                        [chosenCards addObject:otherCard];
                    }
                }
                if([chosenCards count] == 2 ){
                    
                    int matchScore = [card match:chosenCards] + [chosenCards[0] match:@[chosenCards[1]]];
                    switch (matchScore){
                        case 1:
                        case 2:
                        case 4:
                            matchScore = 0;
                            break;
                        case 3:
                        case 7:
                            matchScore *= 3;
                            break;
                        case 12:
                        case 13:
                            matchScore *= 5;
                            break;
                    }
                    if (matchScore < 5 && matchScore !=3){
                        matchScore = 0;
                        
                    }
                    if(matchScore){
                        self.score += (matchScore * MATCH_BONUS);
                        card.chosen = YES;
                        card.matched = YES;
                        for (Card *otherCard in chosenCards) {
                            otherCard.matched = YES;
                        }
                        [self gameLogSendMassage:[NSString stringWithFormat:@"Cards %@, %@ and %@ are match, you got %i points", chosenCards[0],chosenCards[1], card,  (matchScore * MATCH_BONUS)]];
                    }
                    else{
                        self.score -= MISMATCH_PENALTY * 2;
                        card.chosen = YES;
                        for (Card *otherCard in chosenCards) {
                            otherCard.chosen = NO;
                        }
                        [self gameLogSendMassage:[NSString stringWithFormat:@"Cards %@, %@ and %@ are do not match, you lose %i points", chosenCards[0],chosenCards[1], card, MISMATCH_PENALTY * 2]];
                    }
                }
                else {
                    self.score -= COST_TO_CHOOSE;
                    card.chosen = YES;
                    [self gameLogSendMassage:[NSString stringWithFormat:@"You opened the card %@, you lose %i points",card, COST_TO_CHOOSE]];
                }
                
            }
        }
        
    }
    else{
        [self gameLogSendMassage:@"No more card"];
    }
}

@end
