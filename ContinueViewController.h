//
//  ContinueViewController.h
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ContinueViewController : UIViewController

@property (nonatomic, strong) NSString *lastSentence;
@property (nonatomic, strong) NSArray *allSentences;
@property (nonatomic, strong) PFObject *message;
//@property (nonatomic, strong) PFObject *story;
@property (strong, nonatomic) IBOutlet UILabel *previousSentence;
@property (strong, nonatomic) IBOutlet UITextField *sentenceField;

- (IBAction)addSentence:(id)sender;

@end
