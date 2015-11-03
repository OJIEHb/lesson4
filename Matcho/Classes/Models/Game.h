//
//  Game.h
//  Matcho
//
//  Created by Anton Lookin on 10/27/15.
//  Copyright © 2015 geekub. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Deck.h"


@interface Game : UIView

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSString *)gameLog;
- (BOOL) gameEnd;
- (BOOL) haveIsMatchedCard;
- (NSMutableArray*)cards;
- (void) gameLogSendMassage:(NSString *)massage;
@property (nonatomic) NSInteger score;

@end
