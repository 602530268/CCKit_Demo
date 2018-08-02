//
//  CCNestView.h
//  Sample
//
//  Created by chencheng on 2018/7/31.
//  Copyright © 2018年 double chen. All rights reserved.
//

/*
 代码实现借鉴于:
 https://www.jianshu.com/p/88e2b5694765
 我自己进行了封装和改造:
 1.将main tableView换成main scrollView
 2.将frame改成了autolayout
 3.将delegate换成了block
 4.降低耦合性
 */

#import <UIKit/UIKit.h>

@interface CCNestView : UIView

@property(nonatomic,strong) UIView *headerView; //顶部视图，一般为图片或轮播
@property(nonatomic,strong) UIView *segmentView;    //多段选择器
@property(nonatomic,strong) UIView *contentView;    //内容装载

@property(nonatomic,assign) BOOL canScroll; //容器是否可以滚动
@property(nonatomic,strong) NSArray *allowGestureEventPassViews;    //嵌套的所有sub scrollview都放这来
@property(nonatomic,assign) CGFloat segmentViewHeight;  //多段选择器高度，默认40f

/*
 interiorHandleSubScrollViewsScrollDelegate:
 内部进行子滚动视图的scroll代理，默认为NO，即在外部处理。
 一般子view都为tableView，delegate大都会自行处理，此时不适用，但如果可以的话，该类内部处理会方便的多
 注意一点，该值设为YES之后，allowGestureEventPassViews内的scrollView.delegate会被覆盖，除非后来再次赋值
 
 exteriorCallSubScrollViewsScrollDelegate:
 tableView在自行实现了scrollViewDelegate之后，再通过nestView来外部调用，默认为YES
 */
@property(nonatomic,assign) BOOL interiorHandleSubScrollViewsScrollDelegate;
@property(nonatomic,assign) BOOL exteriorCallSubScrollViewsScrollDelegate;

@property(nonatomic,copy) void (^nestMainScrollViewDidScroll)(UIScrollView *scrollView);
@property(nonatomic,copy) void (^nestSubScrollViewDisScroll)(UIScrollView *scrollView);

@property(nonatomic,copy) CGFloat (^nestTableViewContentInsetTop)(void);
@property(nonatomic,copy) CGFloat (^nestTableViewContentInsetBottom)(void);

//sub scrollview 的滚动    public接口，供外部调用
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView;

@end
