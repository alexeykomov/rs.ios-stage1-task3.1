#import "ViewController.h"

typedef NS_ENUM(NSUInteger, Colors) {
    RED = 0,
    BLUE,
    GREEN
};

int LABEL_WIDTH = 70;
int COLOR_LABEL_WIDTH = 100;
int PADDING = 30;

@implementation ViewController

#pragma mark -

- (instancetype)init
{
    self = [super init];
    if (self) {
        colorValueRows = [[NSMutableArray alloc] init];
        colorLabels = [[NSMutableArray alloc] init];
        
        [colorLabels addObject:@"RED"];
        [colorLabels addObject:@"GREEN"];
        [colorLabels addObject:@"BLUE"];
        
        colorLabelIds = [[NSMutableArray alloc] init];
        
        [colorLabelIds addObject:@"labelRed"];
        [colorLabelIds addObject:@"labelGreen"];
        [colorLabelIds addObject:@"labelBlue"];
        
        textFieldIds = [[NSMutableArray alloc] init];
        
        [textFieldIds addObject:@"textFieldRed"];
        [textFieldIds addObject:@"textFieldGreen"];
        [textFieldIds addObject:@"textFieldBlue"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self view].accessibilityIdentifier = @"mainView";
    
    CGRect mainBounds = UIScreen.mainScreen.bounds;
    int width = mainBounds.size.width;
    int textFieldWidth = width - PADDING * 2 - COLOR_LABEL_WIDTH;
    
    CGRect labelRect = CGRectMake(PADDING, 50, COLOR_LABEL_WIDTH, 25);
    label = [[UILabel alloc] initWithFrame:labelRect];
    [label setText:@"Color"];
    label.accessibilityIdentifier = @"labelResultColor";
    [[self view] addSubview:label];
    
    CGRect colorSampleRect = CGRectMake(PADDING + COLOR_LABEL_WIDTH, 50, textFieldWidth, 25);
    colorSample = [[UIView alloc] initWithFrame:colorSampleRect];
    colorSample.accessibilityIdentifier = @"viewResultColor";
    [[self view] addSubview:colorSample];
    [colorSample setBackgroundColor:UIColor.clearColor];

    [self createColorValueRow:0];
    [self createColorValueRow:1];
    [self createColorValueRow:2];
    
    CGRect buttonRect = CGRectMake(0, 0, 100, 25);
    UIButton *process = [[UIButton alloc] initWithFrame:buttonRect];
    process.center = CGPointMake([self view].center.x, 350);
    [process setTitle:@"Process" forState:UIControlStateNormal];
    process.accessibilityIdentifier = @"buttonProcess";
    [process setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    [[self view] addSubview:process];
    
    [process addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchDown];
}

- (void) createColorValueRow:(int) index{
    int verticalOffset = 50 + 70 * (index + 1);
    CGRect mainBounds = UIScreen.mainScreen.bounds;
    int width = mainBounds.size.width;
    int textFieldWidth = width - PADDING * 2 - LABEL_WIDTH;

    CGRect labelRedRect = CGRectMake(PADDING, verticalOffset, LABEL_WIDTH, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRedRect];
    [label setText:[colorLabels objectAtIndex:index]];
    label.accessibilityIdentifier = [colorLabelIds objectAtIndex:index];
    [[self view] addSubview:label];
    
    CGRect valueRedRect = CGRectMake(PADDING + LABEL_WIDTH, verticalOffset, textFieldWidth, 30);
    UITextField *value = [[UITextField alloc] initWithFrame:valueRedRect];
    [value setText:@""];
    value.accessibilityIdentifier = [textFieldIds objectAtIndex:index];
    value.keyboardType = UIKeyboardTypeDecimalPad;
    value.layer.backgroundColor = [UIColor.whiteColor CGColor];
    value.layer.borderColor = [UIColor.grayColor CGColor];
    value.layer.borderWidth = .5;
    value.layer.cornerRadius = 3;
    value.layer.masksToBounds = YES;
    
    [value setPlaceholder:@"0..255"];
    [value setDelegate:self];
    
    [colorValueRows addObject:value];
    [[self view] addSubview:value];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"Text field is called.");
    
    int currentLength = [textField.text length];
    if (currentLength > 2 && ![string isEqualToString:@""]) {
        textField.text = [textField.text substringToIndex:3];
        return NO;
    }
        
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [label setText:@"Color"];
}

- (void) submit:(id) input {
    NSLog(@"Submit is pressed");
    
    NSString* redComponent = [(UITextField*)[colorValueRows objectAtIndex:0] text];
    NSString* greenComponent = [(UITextField*)[colorValueRows objectAtIndex:1] text];
    NSString* blueComponent = [(UITextField*)[colorValueRows objectAtIndex:2] text];
    
    for (int counter = 0; counter < [colorValueRows count]; counter++) {
        UITextField *field = (UITextField*)[colorValueRows objectAtIndex:counter];
        [field setText:@""];
    }
    
    NSLog(@"Red component int: %d", [redComponent intValue]);
    
    if (![self validate:redComponent
                green:blueComponent
                   blue:greenComponent]) {
        [label setText:@"Error"];
        [colorSample setBackgroundColor:UIColor.clearColor];
        [[self view] endEditing:YES];
        return;
    }
    
    CGFloat red = [redComponent intValue];
    red /= 255;
    CGFloat green = [greenComponent intValue];
    green /= 255;
    CGFloat blue = [blueComponent intValue];
    blue /= 255;
    
    NSLog(@"Red: %f", red);
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    NSString *hexValue = [self formatColorToHex:[redComponent intValue]
                                          green:[greenComponent intValue]
                                           blue:[blueComponent intValue]
                                          ];
    NSLog(@"Hex value: %@", hexValue);
    [label setText:hexValue];
    
    [colorSample setBackgroundColor:color];
    [[self view] endEditing:YES];
    
    NSLog(@"Red component string: %@", redComponent);
}

- (BOOL) validate:(NSString *) red green:(NSString *) green blue:(NSString *) blue {
    if ([red length] == 0 || [green length] == 0 || [blue length] == 0) {
        return NO;
    }
    
    NSString *verificationRegEx = @"^\\s*\\d+\\s*$";
    NSUInteger redLoc = [red rangeOfString:verificationRegEx options:NSRegularExpressionSearch].location;
    NSUInteger greenLoc = [green rangeOfString:verificationRegEx options:NSRegularExpressionSearch].location;
    NSUInteger blueLoc = [blue rangeOfString:verificationRegEx options:NSRegularExpressionSearch].location;
    if (redLoc == NSNotFound || greenLoc == NSNotFound || blueLoc == NSNotFound) {
        return NO;
    }
    
    int redComp = [red intValue];
    int greenComp = [green intValue];
    int blueComp = [blue intValue];
    if (redComp >= 0 && redComp < 256 && blueComp >= 0 && blueComp < 256 && greenComp >= 0 && greenComp < 256) {
        return YES;
    }
    return NO;
}

- (NSString*) formatColorToHex:(int) red green:(int) green blue:(int) blue {
    NSString *clr = [NSString stringWithFormat:@"0x%@%@%@",
                            [self formatColorComponentToHex:red],
                            [self formatColorComponentToHex:green],
                            [self formatColorComponentToHex:blue]
                            ];
    NSLog(@"Formatted color: %@", clr);
    return clr;
}

- (NSString*) formatColorComponentToHex:(int) red {
    NSString *clr = [NSString stringWithFormat:@"%X", red];
    if ([clr length] < 2) {
        clr = [@"0" stringByAppendingString:clr];
    }
    NSLog(@"Formatted color: %@", clr);
    return clr;
}

 
@end
