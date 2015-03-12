//
//  CustomCollectionViewLayout.m
//  2015-03-12-CustomUICollectionViewLayout
//
//  Created by TangJR on 15/3/12.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import "CustomCollectionViewLayout.h"

@interface CustomCollectionViewLayout ()

@property (assign, nonatomic) CGFloat leftY; // 左侧起始Y轴
@property (assign, nonatomic) CGFloat rightY; // 右侧起始Y轴
@property (assign, nonatomic) NSInteger cellCount; // cell个数
@property (assign, nonatomic) CGFloat itemWidth; // cell宽度
@property (assign, nonatomic) CGFloat insert; // 间距

@end

@implementation CustomCollectionViewLayout

/**
 *  初始化layout后自动调动，可以在该方法中初始化一些自定义的变量参数
 */
- (void)prepareLayout {
    
    [super prepareLayout];
    
    // 初始化参数
    _cellCount = [self.collectionView numberOfItemsInSection:0]; // cell个数，直接从collectionView中获得
    _insert = 10; // 设置间距
    _itemWidth = SCREEN_WIDTH / 2 - 3 * _insert; // cell宽度
}

/**
 *  设置UICollectionView的内容大小，道理与UIScrollView的contentSize类似
 *
 *  @return 返回设置的UICollectionView的内容大小
 */
- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(SCREEN_WIDTH, MAX(_leftY, _rightY));
}

/**
 *  初始Layout外观
 *
 *  @param rect 所有元素的布局属性
 *
 *  @return 所有元素的布局
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    _leftY = _insert; // 左边起始Y轴
    _rightY = _insert; // 右边起始Y轴
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.cellCount; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
}

/**
 *  根据不同的indexPath，给出布局
 *
 *  @param indexPath
 *
 *  @return 布局
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取代理中返回的每一个cell的大小
    CGSize itemSize = [self.layoutDelegate collectionView:self.collectionView collectionViewLayout:self sizeOfItemAtIndexPath:indexPath];
    
    // 防止代理中给的size.width大于(或小于)layout中定义的width，所以等比例缩放size
    CGFloat itemHeight = floorf(itemSize.height * self.itemWidth / itemSize.width);
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 判断当前的item应该在左侧还是右侧
    BOOL isLeft = _leftY < _rightY;
    
    if (isLeft) {
        
        CGFloat x = _insert; // x轴起始位置为0
        attributes.frame = CGRectMake(x, _leftY, _itemWidth, itemHeight);
        _leftY += itemHeight + _insert; // 设置新的Y起点
    }
    
    if (!isLeft) {
        
        CGFloat x = _itemWidth + 2 * _insert;
        attributes.frame = CGRectMake(x, _rightY, _itemWidth, itemHeight);
        _rightY += itemHeight + _insert;
    }
    
    return attributes;
}

@end