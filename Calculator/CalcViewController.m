//
//  CalcViewController.m
//  Calculator
//
//  Created by Lazy.TJU on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalcViewController.h"
#import "CalcBrain.h"

@interface CalcViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;  //Test whether the user is entering a number
@property (nonatomic,strong)CalcBrain *brain;                   //an instance of Calcbrain class
@property (nonatomic,strong)NSString *operatorPressed;          //To save the operator user presses
@property (nonatomic) BOOL minusOrPositive;                     //A bool variable to judge whether the user have pressed the POSTIVE/MINUS button
@property (nonatomic) BOOL isSpecialButton;                     //A bool variable to judge whether the operator user have pressed is a special operator button(ln,sin,square etc)
@property (nonatomic) BOOL isOnceDot;                           //A bool variable to limit the appearance of "."(only once)
@property (nonatomic) BOOL boolTest;
@end

@implementation CalcViewController

@synthesize display = _display;
@synthesize algoDisplay = _algoDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = 
    _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize operatorPressed = _operatorPressed;
@synthesize minusOrPositive = _minusOrPositive;
@synthesize isSpecialButton = _isSpecialButton;
@synthesize isOnceDot = _isOnceDot;
@synthesize boolTest = _boolTest;

-(CalcBrain *)brain
{
    if(! _brain) _brain = ([[CalcBrain alloc] init]);
    return _brain;
}


- (IBAction)DigitPressed:(UIButton *)sender       //method when a digit button is pressed
{
    NSString *digit = [sender currentTitle];      //use an NSString variable to save the current button
    if([digit isEqualToString:@"."] && self.isOnceDot == NO)self.isOnceDot = YES;   //judge the appearance of dot
    else if ([digit isEqualToString:@"."] && self.isOnceDot != NO) {
        return;
    }
    if(self.userIsInTheMiddleOfEnteringANumber)   //if the user is entering a number
    {
        self.display.text = [self.display.text stringByAppendingString:digit];     //both the below line and the above line append the input digit
        self.algoDisplay.text = [self.algoDisplay.text stringByAppendingString:digit];
    }
    else                                          //if not
    {
        if(![digit isEqualToString:@"0"])          // don't allow a leading zero
        {
            self.display.text = digit;             
            if(!self.operatorPressed || [self.operatorPressed isEqualToString:@""])   //update the above line to "0" if the above line is not used again
            {
                self.algoDisplay.text = @"0";
            }
            if(![self.algoDisplay.text isEqualToString:@"0"])          
            {
                self.algoDisplay.text = [self.algoDisplay.text stringByAppendingString:digit];
            }
            else self.algoDisplay.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;          //reset the status
        }
    }
}
- (IBAction)enterPressed            //method when the equal button is pressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];       //push the number in front of "=" into stack
    self.userIsInTheMiddleOfEnteringANumber = NO;
    double result = [self.brain performOperation:self.operatorPressed testSpecialButton:self.isSpecialButton];   //do the operation
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;                   //display the result
    self.algoDisplay.text = self.display.text;
    self.operatorPressed = @"";
    self.isOnceDot = NO;
    //self.minusOrPositive = 
}

- (IBAction)operationPressed:(UIButton *)sender    //method when an operator(not special) is pressed
{
    if((!self.operatorPressed || [self.operatorPressed isEqualToString:@""]) || (self.display.text && self.userIsInTheMiddleOfEnteringANumber != NO))
    {
        [self.brain pushOperand:[self.display.text doubleValue]];
        self.operatorPressed = sender.currentTitle;
        [self.brain pushOperandOperator:self.operatorPressed];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.algoDisplay.text = [self.algoDisplay.text stringByAppendingString:self.operatorPressed];
        self.display.text = @"0";
        self.isSpecialButton = NO;
    }
    self.isOnceDot = NO;
}

- (IBAction)clearPressed:(id)sender         //method when CE button is pressed
{
    [self.brain clearStack];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.display.text = @"0";
    self.algoDisplay.text = @"0";
    self.isOnceDot = NO;
}

- (IBAction)MinusOrPositive:(id)sender      //method to deal the POSITIVE/MINUS button
{
    self.minusOrPositive = YES;
    if(self.minusOrPositive && self.userIsInTheMiddleOfEnteringANumber == NO){      
        NSString *resultString = [NSString stringWithFormat:@"%g", 0 - self.display.text.doubleValue];
        self.display.text = resultString;
        self.minusOrPositive = NO;}
    //if(self.userIsInTheMiddleOfEnteringANumber == NO)
    //{
        if([self.operatorPressed isEqualToString:@""] && ![self.algoDisplay.text isEqualToString:@"0"] && self.userIsInTheMiddleOfEnteringANumber == NO){
            self.algoDisplay.text = [NSString stringWithFormat:@"%g", 0 - self.algoDisplay.text.doubleValue];
        } else if (!self.operatorPressed || [self.algoDisplay.text isEqualToString:@"0"]) {
            self.algoDisplay.text = @"-";
        }else if(self.userIsInTheMiddleOfEnteringANumber == NO){
            self.algoDisplay.text = [self.algoDisplay.text stringByAppendingString:@"-"];
        }
    //}
    if([self.display.text isEqualToString:@"0"])self.display.text = @"-";
    self.userIsInTheMiddleOfEnteringANumber = YES;
}

- (void)viewDidUnload {
    [self setAlgoDisplay:nil];
    [super viewDidUnload];
    self.isOnceDot = NO;
}

- (IBAction)specialButtonPressed:(UIButton *)sender   //method when special button is pressed
{
    if((!self.operatorPressed || [self.operatorPressed isEqualToString:@""]) || (self.display.text && self.userIsInTheMiddleOfEnteringANumber != NO))
    {
        self.isSpecialButton = YES;
        self.operatorPressed = sender.currentTitle;
        [self.brain pushOperand:[self.display.text doubleValue]];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.algoDisplay.text = [self.algoDisplay.text stringByAppendingString:self.operatorPressed];
        self.display.text = @"0";
    }
    
}


@end
