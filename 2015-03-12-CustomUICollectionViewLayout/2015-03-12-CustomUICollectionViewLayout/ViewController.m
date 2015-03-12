//
//  ViewController.m
//  2015-03-12-CustomUICollectionViewLayout
//
//  Created by TangJR on 15/3/12.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionViewLayout.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CustomCollectionViewLayoutDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *itemHeights;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource {
    
    _dataSource = [[NSMutableArray alloc] init];
    _itemHeights = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 10; i ++) {
        
        [_dataSource addObject:@"1"];
        
        CGFloat itemHeight = arc4random() % 200 + 20;
        [_itemHeights addObject:@(itemHeight)];
    }
}

- (void)initializeUserInterface {
    
    CustomCollectionViewLayout *layout = [[CustomCollectionViewLayout alloc] init];
    layout.layoutDelegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor redColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - CustomCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView collectionViewLayout:(CustomCollectionViewLayout *)collectionViewLayout sizeOfItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH / 2 - 3 * 10, [_itemHeights[indexPath.row] floatValue]);
}

@end