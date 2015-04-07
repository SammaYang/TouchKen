//
//  ViewController.m
//  TouchKen
//
//  Created by Mac User on 2015/1/30.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "ViewController.h"
#import "Ken.h"

/*Deletage : 3.代表 ViewController 有採用 KenDelegate 所定義的 method => Ken:didFinishedMovedWithStatus:
               意思是，ViewController將透過KenDelegate這個protocol，建立秘密通道 => Ken:didFinishedMovedWithStatus:
 */
@interface ViewController () <KenDelegate>
{
    NSInteger nTag;
}
@property (weak, nonatomic) IBOutlet UIView *gray;
@property (weak, nonatomic) IBOutlet UIView *grayFrame;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    nTag = 1;
    self.grayFrame.tag = 9999;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//點擊螢幕時，生成一個ken類別並且顯示在畫面上
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //取得現在在畫面上touch的位置
    CGPoint point = [ [touches anyObject] locationInView:self.view ];
    //生成一個Ken類別物件(回傳一個UIView，裡面包著UIImageView)
    //nTag%2，切換ken是左是右，所以這次是左，下次便是右
    Ken *ken = [[Ken alloc] initWithPoint:point atDirection:nTag%2];
    //Delegate : 5.把「物件名稱.delegate」指定為自己這個物件，因此在Ken類的物件method => GoRight，「self.delegate」才知道是指哪個物件 => ViewController
    ken.delegate = self;
    //每一個生成的ken都給予一個tag來標記
    ken.tag = nTag;
    //下一個ken的tag是現在這個ken的tag + 1
    nTag++;
    //在self.view，addSubview，放一個ken類別的物件
    [self.view addSubview:ken];
}
//讓ken往左走
- (IBAction)kenLeftAction:(id)sender {
    //取得self.view底下所有的subview(全部的ken)，最後那隻(最上層的)
    Ken *now = [self.view.subviews lastObject];
    //呼叫物件方法，讓ken往左走
    [now GoLeft];
    
    //subviews是一個陣列，可以搭配tag去取得特定的ken
    /*
    for (UIView *viewX in self.view.subviews) {
        if ( [viewX isKindOfClass:[Ken class]] ) {
            NSLog(@"%@", viewX);
        }
    }
    */
}
//讓ken往右走
- (IBAction)kenRightAction:(id)sender {
    Ken *now = [self.view.subviews lastObject];
    [now GoRight];
}

//Deletage : 4.實作秘密通道的method => Ken:didfinishedMovedWithStatus:
-(void)Ken:(Ken *)ken didFinishedMovedWithStatus:(NSDictionary *)status
{
    //NSLog(@"%@", status);
    
    //呼叫CGRectIntersectsRect這個偵測碰撞的method，當ken.frame和self.gray.frame碰撞的時候，回傳boolean，true就是撞到了
    if (CGRectIntersectsRect(ken.frame, self.gray.frame)) {
        //把ken這個物件從UIViewController(superview)移除
        [ken removeFromSuperview];
    }
}

- (void)didTouchedKenTag:(long)tag
{
    NSLog(@"You touch Ken id: %ld", tag);
}
//當ken被拖進grayFrame
- (void)didDropInGray:(long)tag
{
    //把指定tag的物件從UIViewController(superview)移除
    //[self.view viewWithTag:tag] => 取ViewController底下，UIView物件.tag = 目前所傳入的tag(所以用viewWithTag，抓到指定tag的view)，然後remove它
    [[self.view viewWithTag:tag] removeFromSuperview];
}

@end
