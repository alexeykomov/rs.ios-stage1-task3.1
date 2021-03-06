#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UITextFieldDelegate>

{
    NSMutableArray<UIView *> *colorValueRows;
    NSMutableArray<NSString *> *colorLabels;
    NSMutableArray<NSString *> *colorLabelIds;
    NSMutableArray<NSString *> *textFieldIds;
    UILabel *label;
    UIView *colorSample;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
