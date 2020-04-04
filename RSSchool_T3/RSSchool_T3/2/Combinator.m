#import "Combinator.h"

long long factorial(int input) {
    if (input == 0 || input == 1) {
        return 1;
    }
    long long current = 1;
    for (int counter = 2; counter <= input; counter++) {
        current = current * counter;
    }
    return current;
}

@implementation Combinator
- (NSNumber*)chechChooseFromArray:(NSArray <NSNumber*>*)array {
    long long combinations = [(NSNumber*) [array objectAtIndex:0] longLongValue];
    int colorPool = [(NSNumber*) [array objectAtIndex:1] intValue];
    int minUsedColors = INT_MAX;
    int numberOfColorsUsed = 1;
    long long colorPoolFactorial = factorial(colorPool);
    while (numberOfColorsUsed <= colorPool) {
        long long calculatedCombinations = colorPoolFactorial /
            (factorial(numberOfColorsUsed) *
             factorial(colorPool - numberOfColorsUsed)
            );
        NSLog(@"Factorial colorPool: %lld", factorial(colorPool));
        NSLog(@"Calculated combinations: %lld", calculatedCombinations);
        NSLog(@"Number of colors used: %d", numberOfColorsUsed);
        
        if (calculatedCombinations == combinations) {
            if (numberOfColorsUsed < minUsedColors) {
                minUsedColors = numberOfColorsUsed;
            }
        }
        numberOfColorsUsed++;
    }
    return minUsedColors == INT_MAX ? nil : @(minUsedColors);
}
@end
