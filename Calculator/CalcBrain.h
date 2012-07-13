//
//  CalcBrain.h
//  Calculator
//
//  Created by Lazy.TJU on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CalcBrain : NSObject
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation
         testSpecialButton: (BOOL)isSpecialButton;
- (void)clearStack;
- (void)pushOperandOperator:(NSString *)operand;
- (NSString *)popOperandOperator;
@end
