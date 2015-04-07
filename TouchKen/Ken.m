//
//  Ken.m
//  TouchKen
//
//  Created by Mac User on 2015/1/30.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "Ken.h"

@implementation Ken

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/* point => 現在所點擊的位置
   direction => 1: 往右
 */
- (Ken *)initWithPoint:(CGPoint) point atDirection:(int) direction
{
    self = [super init];
    if (self) {
        //宣告一個UIImageView的類別，並且初始化(放一張image叫ken1.png的圖檔)
        UIImageView *kenImageView = [ [UIImageView alloc] initWithImage:[UIImage imageNamed:@"ken1.png"] ];
        //取得kenImageView的寬與高
        CGSize imageSize = kenImageView.frame.size;
        /*
         透過CGRectMake來指定self.frame的x、y座標，寬與高為多少
         point.x-imageSize.width/2, point.y-imageSize.height*0.8是處理圖片出現時的x、y座標與點擊點的位置關係
         */
        self.frame = CGRectMake(point.x-imageSize.width/2, point.y-imageSize.height*0.8, imageSize.width, imageSize.height);
        
        NSArray *imgArrays = @[[UIImage imageNamed:@"ken1.png"],
                               [UIImage imageNamed:@"ken2.png"],
                               [UIImage imageNamed:@"ken3.png"],
                               [UIImage imageNamed:@"ken4.png"],
                               [UIImage imageNamed:@"ken5.png"],
                               [UIImage imageNamed:@"ken6.png"]
                               ];
        
        //如果往右，放的圖片就是往右的，那麼人物看起來就是往右邊
        if(direction == 1) {
            imgArrays = @[[UIImage imageNamed:@"ken1r.png"],
                          [UIImage imageNamed:@"ken2r.png"],
                          [UIImage imageNamed:@"ken3r.png"],
                          [UIImage imageNamed:@"ken4r.png"],
                          [UIImage imageNamed:@"ken5r.png"],
                          [UIImage imageNamed:@"ken6r.png"]
                          ];

        }
        
        //把自己(UIView)的背景色變成黃色
        //self.backgroundColor = [UIColor yellowColor];
        
        //設定播放圖片
        kenImageView.animationImages = imgArrays;
        //播放速度
        kenImageView.animationDuration = 0.8;
        //開始播放
        [kenImageView startAnimating];
        
        //把UIImageView加到自己這個UIView
        [self addSubview:kenImageView];
    }
    //所以回傳的是一個UIView，裡面放了UIImageView
    return self;
}
//點一下
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //把self這個UIView帶到最前面
    [ [self superview] bringSubviewToFront:self];
    //取得點擊點座標
    CGPoint point = [ [touches anyObject] locationInView:self ];
    
    //把第一次touch的點，記錄到全域變數location
    location = point;
    
    //呼叫Ken:didTouchedKenTag: ，顯示Ken的tag
    [self.delegate didTouchedKenTag:self.tag];
    
}
//持續移動
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //取得移動中的座標，指的是ken這個UIView的座標，不是superview，兩者不同
    CGPoint point = [ [touches anyObject] locationInView:self];
    
    //宣告一個新的frame => 物件的外框
    CGRect newframe = self.frame;
    
    //這個新frame的位置(左上角x)是原本的位置 + 目前移動的x座標 - 第一次touch的x座標
    newframe.origin.x = newframe.origin.x + point.x - location.x;
    //NSLog(@"%f", point.x);
    newframe.origin.y = newframe.origin.y + point.y - location.y;
    
    //設置self這個UIView的新外框位置 = 剛才設定的newframe物件新位置
    [self setFrame:newframe];
}
//把ken拖進某個地方而且滑鼠放開的時候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //grayFrame => Ken這個UIView的上一階 => ViewController => self.view，取他下面tag = 9999的UIView
    UIView *grayFrame = [ [self superview] viewWithTag:9999];
    //當ken和grayFrame碰撞的時候
    if (CGRectIntersectsRect(self.frame, grayFrame.frame) ) {
        [self.delegate didDropInGray:self.tag];
        
    }
}
//讓ken往左走
- (void) GoRight
{
    //設定讓self這個UIView，用0.2秒的時間，移動到指定位置
    [UIView transitionWithView:self
                      duration:0.2
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        //宣告一個新的frame => 物件的外框
                        CGRect newFrame = self.frame;
                        //這個新frame的位置(左上角x)是原本的位置 + 50
                        newFrame.origin.x = newFrame.origin.x + 50;
                        
                        //設置self這個UIView的新外框位置 = 剛才設定的newFrame所描述的新位置
                        [self setFrame:newFrame];
                    }
                    completion:^(BOOL finished) {
                        //Delegate : 2.建立一個NSDictionary，寫入各種狀態
                        NSDictionary *status = @{@"status":@"Moving finished.",
                                                 @"direction":@"Right.",
                                                 @"tag":[NSNumber numberWithLong:self.tag]};
                        //當有人說self.delegate這個屬性，就call Ken:didFinishedMovedWithStatus:這個method，並且把status這個NSDictionary物件傳過去。在ViewController.m裡，指定self.delegate是一個ViewController本身
                        [self.delegate Ken:self didFinishedMovedWithStatus:status];
                    }];
}

//讓ken往右走
- (void) GoLeft
{
    [UIView transitionWithView:self
                      duration:0.2
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        //宣告一個新的frame => 物件的外框
                        CGRect newFrame = self.frame;
                        //這個新frame的位置(左上角x)是原本的位置 - 50
                        newFrame.origin.x = newFrame.origin.x - 50;
                        
                        //設置self這個UIView的新外框位置 = 剛才設定的newframe物件新位置
                        [self setFrame:newFrame];
                    }
                    completion:^(BOOL finished) {
                        //Delegate : 2.建立一個NSDictionary，寫入各種狀態
                        NSDictionary *status = @{@"status":@"Moving finished.",
                                                 @"direction":@"Left.",
                                                 @"tag":[NSNumber numberWithLong:self.tag]};
                        //當有人說self.delegate這個屬性，就call Ken:didFinishedMovedWithStatus:這個method，並且把status這個NSDictionary物件傳過去。在ViewController.m裡，指定self.delegate是一個ViewController本身
                        [self.delegate Ken:self didFinishedMovedWithStatus:status];
                    }];
}

@end
