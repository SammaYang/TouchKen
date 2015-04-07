//
//  Ken.h
//  TouchKen
//
//  Created by Mac User on 2015/1/30.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate : 1.要寫在interface的上面，要有這一句;如果沒這一句，@protocol KenDelegate的宣告要移到@interface的後面，不然認不得Ken型態是在說誰
@class Ken;

//Delegate : 1.定義protocol名稱=>通常是類別名稱+Delegate
@protocol KenDelegate <NSObject>
    //Delegate : 1.秘密通道(@optional=>非必要性 ; @required=>必要性 ; 出於宣告的意圖，並不是一定必要)
    //另一種解釋:把Ken:didFinishedMovedWithStatus:這個method委任給其它類別完成(有遵循KenDelegate這個protocol的都是)
    @optional
    - (void)Ken:(Ken *)ken didFinishedMovedWithStatus:(NSDictionary *)status;
    - (void)didTouchedKenTag:(long)tag;
    - (void)didDropInGray:(long)tag;
@end

//This is Class
@interface Ken : UIView
{
    CGPoint location;
}

//Delegate : 1.宣告一個屬性，後續可以透過Ken類的物件.delegate來存取後續設定給「物件.delegate」的內容
@property (strong, nonatomic) id<KenDelegate> delegate;

- (Ken *)initWithPoint:(CGPoint) point atDirection:(int) direction;

- (void) GoRight;
- (void) GoLeft;

@end
