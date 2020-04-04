#import "PolynomialConverter.h"

@implementation PolynomialConverter

NSString* sign(int value) {
    if (value > 0) {
        return @"+";
    }
    if (value < 0) {
        return @"-";
    }
    return @"";
}

NSString* degreePart(int degree) {
    if (degree == 0) {
        return @"";
    }
    if (degree == 1) {
        return @"x";
    }
    return [NSString stringWithFormat:@"x^%d", degree];
}

NSString* coefficientPart(BOOL first, int coefficient) {
    NSString *signPart = [NSString stringWithFormat:@"%@",
                          first && coefficient < 0 ?
                            sign(coefficient) :
                            @""];
    NSString *coefficientPart = abs(coefficient) > 1 ?
        [@(abs(coefficient)) stringValue] :
        @"";
    return [NSString stringWithFormat:@"%@%@", signPart, coefficientPart];
}

- (NSString*)convertToStringFrom:(NSArray <NSNumber*>*)numbers {
    int maxDegree = [numbers count];
    NSMutableString *acc = maxDegree > 0 ? [[NSMutableString alloc] init] : nil;
    for (int counter = 0; counter < [numbers count]; counter++) {
        if (![numbers objectAtIndex:counter]) {
            continue;
        }
        int current = [(NSNumber*)[numbers objectAtIndex:counter] intValue];
        if (current == 0) {
            continue;
        }
        NSString *prefix = counter == 0 ? @"" :
            [NSString stringWithFormat:@" %@ ", sign(current)];
        [acc appendString:[NSString stringWithFormat:
                           @"%@%@%@",
                           prefix,
                           coefficientPart(counter == 0, current),
                           degreePart(maxDegree - counter - 1)
                           ]];
    }
    return acc;
}
@end
