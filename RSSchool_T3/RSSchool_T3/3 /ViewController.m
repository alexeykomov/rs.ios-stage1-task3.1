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
        [colorLabels addObject:@"BLUE"];
        [colorLabels addObject:@"GREEN"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect mainBounds = UIScreen.mainScreen.bounds;
    int width = mainBounds.size.width;
    int textFieldWidth = width - PADDING * 2 - COLOR_LABEL_WIDTH;
    
    CGRect labelRect = CGRectMake(PADDING, 50, COLOR_LABEL_WIDTH, 25);
    label = [[UILabel alloc] initWithFrame:labelRect];
    [label setText:@"0xffffff"];
    [[self view] addSubview:label];
    
    
    
    CGRect colorSampleRect = CGRectMake(PADDING + COLOR_LABEL_WIDTH, 50, textFieldWidth, 25);
    colorSample = [[UIView alloc] initWithFrame:colorSampleRect];
    [[self view] addSubview:colorSample];
    [colorSample setBackgroundColor:UIColor.clearColor];

    [self createColorValueRow:0];
    [self createColorValueRow:1];
    [self createColorValueRow:2];
    
    CGRect buttonRect = CGRectMake((width - 100) / 2, 350, 100, 25);
    UIButton *process = [[UIButton alloc] initWithFrame:buttonRect];
    [process setTitle:@"Process" forState:UIControlStateNormal];
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
    UILabel *labelRed = [[UILabel alloc] initWithFrame:labelRedRect];
    [labelRed setText:[colorLabels objectAtIndex:index]];
    [[self view] addSubview:labelRed];

    [labelRed setBackgroundColor:UIColor.systemTealColor];
    
    CGRect valueRedRect = CGRectMake(PADDING + LABEL_WIDTH, verticalOffset, textFieldWidth, 30);
    UITextField *valueRed = [[UITextField alloc] initWithFrame:valueRedRect];
    [valueRed setText:@""];
    valueRed.layer.backgroundColor = [UIColor.whiteColor CGColor];
    valueRed.layer.borderColor = [UIColor.grayColor CGColor];
    valueRed.layer.borderWidth = .5;
    valueRed.layer.cornerRadius = 3;
    valueRed.layer.masksToBounds = YES;
    
    [valueRed setPlaceholder:@"0..255"];
    [valueRed setDelegate:self];
    
    [colorValueRows addObject:valueRed];
    [[self view] addSubview:valueRed];
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

- (void) submit:(id) input {
    NSLog(@"Submit is pressed");
    
    NSString* redComponent = [(UITextField*)[colorValueRows objectAtIndex:0] text];
    NSString* greenComponent = [(UITextField*)[colorValueRows objectAtIndex:1] text];
    NSString* blueComponent = [(UITextField*)[colorValueRows objectAtIndex:2] text];
    
    for (int counter = 0; counter < [colorValueRows count]; counter++) {
        [(UITextField*)[colorValueRows objectAtIndex:counter] setText:@""];
    }
    
    CGFloat red = [redComponent intValue] / 255;
    CGFloat green = [greenComponent intValue] / 255;
    CGFloat blue = [blueComponent intValue] / 255;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    NSString *hexValue = [NSString stringWithFormat:@"0x%X%X%X",
                          [redComponent intValue],
                          [greenComponent intValue],
                          [blueComponent intValue]];
    NSLog(@"Hex value: %@", hexValue);
    [label setText:hexValue];
    
    [colorSample setBackgroundColor:color];
    
    NSLog(@"Red component: %@", redComponent);
}
 
@end
