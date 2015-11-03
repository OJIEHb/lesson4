//
//  ViewController.m
//  Matcho
//
//  Created by Anton Lookin on 10/19/15.
//  Copyright © 2015 geekub. All rights reserved.
//

#import "GameOnThreeCard.h"
#import "PlayingCardDeck.h"

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) GameOnThreeCard *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLogLabel;

@end

@implementation ViewController

- (GameOnThreeCard *)game {
    if (!_game) {
        _game = [[GameOnThreeCard alloc] initWithCardCount:[self.cardButtons count]
                                      usingDeck:[[PlayingCardDeck alloc] init]];
    }
    return _game;
}


- (IBAction)cardButtonTapped:(UIButton *)sender {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    
    [self updateUI];
}


-(void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]forState:UIControlStateNormal];
        if (card.isMatched || self.game.gameEnd)  {cardButton.enabled = NO;}
        
    }
    NSString *score = [NSString stringWithFormat:@"Score: %@", @(self.game.score)];
    [self.scoreLabel setText: score];
    [self.gameLogLabel setText: self.game.gameLog];
}


-(NSString *) titleForCard:(Card *)card {
    return (card.isChosen) ? card.contents : @"";
}


-(UIImage *) backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:(card.isChosen) ? @"cardfront" : @"cardback"];
}




@end
