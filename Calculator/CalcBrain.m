//
//  CalcBrain.m
//  Calculator
//
//  Created by Lazy.TJU on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalcBrain.h"

@interface CalcBrain()
@property (nonatomic,strong) NSMutableArray *operandStack;
@property (nonatomic,strong) NSMutableArray *operandStackOperator;
@end


@implementation CalcBrain

@synthesize operandStack = _operandStack;
@synthesize operandStackOperator = _operandStackOperator;

- (NSMutableArray *)operandStack
{
    if(_operandStack == nil)_operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void)setOperandStack:(NSMutableArray *)operandStack
{
    _operandStack = operandStack;
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if(operandObject)[self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (NSMutableArray *)operandStackOperator
{
    if(_operandStackOperator == nil)_operandStackOperator = [[NSMutableArray alloc] init];
    return _operandStackOperator;
}

- (void)setOperandStackOperator:(NSMutableArray *)operandStackOperator
{
    _operandStackOperator = operandStackOperator;
}

- (void)pushOperandOperator:(NSString *)operand
{
    [self.operandStackOperator addObject:operand];
}

- (NSString *)popOperandOperator
{
    NSString *operandObject = [self.operandStackOperator lastObject];
    if(operandObject)[self.operandStackOperator removeLastObject];
    return operandObject;
}

- (double)performOperation:(NSString *)operation
          testSpecialButton:(BOOL)isSpecialButton
{
    double result = 0,resultTemp = 0;
    NSString *operatorResult,*operatorPlus;
    int countOperator = 0;
    resultTemp = [[self.operandStack objectAtIndex: countOperator] doubleValue];
    while(isSpecialButton == NO)     //this process can deal with the priority of the operation
    {
        int i;
        i = countOperator + 1;
        if(![self.operandStackOperator count])break;
        if([[self.operandStackOperator objectAtIndex:countOperator] isEqualToString:@"+"] || [[self.operandStackOperator objectAtIndex:countOperator] isEqualToString:@"-"])
        {
            if(i < [self.operandStackOperator count]){
                operatorResult = [self.operandStackOperator objectAtIndex: i];
                result = [[self.operandStack objectAtIndex:i] doubleValue];}
            else {
                result = [[self.operandStack objectAtIndex:i] doubleValue];
                operatorResult = @"";
            }
            while([operatorResult isEqualToString:@"*"] || [operatorResult isEqualToString:@"/"])
            {
                result = [operatorResult isEqualToString:@"*"] ? result * [[self.operandStack objectAtIndex:i+1] doubleValue] : result / [[self.operandStack objectAtIndex:i+1] doubleValue];
                i++;
                if(i == [self.operandStackOperator count])break;
                operatorResult = [self.operandStackOperator objectAtIndex:i];
            }
            operatorPlus = [self.operandStackOperator objectAtIndex:countOperator];
            resultTemp = ([operatorPlus isEqualToString:@"+"])
            ?   resultTemp + result
            :   resultTemp - result;
            countOperator = i;
            if(i == [self.operandStackOperator count])break;
        }
        else {
            operatorResult = [self.operandStackOperator objectAtIndex:countOperator];
            resultTemp = [operatorResult isEqualToString:@"*"] ? resultTemp * [[self.operandStack objectAtIndex:countOperator + 1] doubleValue] : resultTemp / [[self.operandStack objectAtIndex:countOperator + 1] doubleValue];
            countOperator++;
            if(i == [self.operandStackOperator count])break;
        }
    }
    if(isSpecialButton != NO)
    {
        if ([operation isEqualToString:@"²"]) {
            result = [[self.operandStack objectAtIndex:0] doubleValue];
            resultTemp = result * result;
        }
        else if ([operation isEqualToString:@"ln"]) {
            result = [[self.operandStack objectAtIndex:0] doubleValue];
            resultTemp = log(result);
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = [[self.operandStack objectAtIndex:0] doubleValue];
            resultTemp = sin(result);
        }
        else if ([operation isEqualToString:@"^"]) {
            result = [[self.operandStack objectAtIndex:0] doubleValue];
            resultTemp = [[self.operandStack objectAtIndex:1] doubleValue];
            resultTemp = pow(result,resultTemp);
        }
        else if([operation isEqualToString:@"√"]){
            result = [[self.operandStack objectAtIndex:0] doubleValue];
            resultTemp = sqrt(result);
        }
    }
    /*if([operation isEqualToString:@"+"]) {
     result = popFirstNumber + popSecondNumber + popThirdNumber;
     } else if ([operation isEqualToString:@"*"]) {
     result = popFirstNumber * popSecondNumber;
     } else if ([operation isEqualToString:@"-"]) {
     result = popSecondNumber - popFirstNumber;
     } else if ([operation isEqualToString:@"/"]) {
     result = popSecondNumber / popFirstNumber;
     } else if ([operation isEqualToString:@"√"]) {
     result = sqrt(popSecondNumber);
     } else if ([operation isEqualToString:@"²"]) {
     result = popSecondNumber * popSecondNumber;
     } else if ([operation isEqualToString:@"ln"]) {
     result = log(popSecondNumber);
     } else if ([operation isEqualToString:@"sin"]) {
     result = sin(popSecondNumber);
     } else if ([operation isEqualToString:@"^"]) {
     result = pow(popSecondNumber,popFirstNumber);
     } else {
     result = popFirstNumber;
     }*/
    [self.operandStack removeAllObjects];
    [self.operandStackOperator removeAllObjects];
    //[self pushOperand:resultTemp];    
    return resultTemp;
}
- (void)clearStack
{
    [self.operandStack removeAllObjects];
    [self.operandStackOperator removeAllObjects];
}
@end
