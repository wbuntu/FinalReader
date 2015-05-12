//
//  ViewController.m
//  FinalReader
//
//  Created by 武鸿帅 on 15/4/28.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "ShelfVC.h"
#import "LocalFileVC.h"
#import "VolumeManager.h"
#import "ShelfTVCCellCollectionViewCell.h"
@interface ShelfVC ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong) NSArray *bookIdStrArray;
@property(nonatomic,strong) NSMutableDictionary *imageDic;

@end

@implementation ShelfVC
{
    VolumeManager *manager;
}
static NSString *identifier = @"cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChanged) name:@"booksChanged" object:nil];
    _imageDic = [NSMutableDictionary dictionary];
    manager = [VolumeManager defaultManager];
    NSArray *keys = [manager.books allKeys];
    _bookIdStrArray = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj1];
    }];
    self.title=@"书架";
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
//    NSLog(@"%@",_bookIdStrArray);
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateLongPress:)];
    recognizer.delegate=self;
    [self.view addGestureRecognizer:recognizer];
}
-(void)activateLongPress:(UILongPressGestureRecognizer *)sender
{
    
}
-(void)dataChanged
{
    NSArray *keys = [manager.books allKeys];
    _bookIdStrArray = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj1];
    }];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.collectionView reloadData];
}

#pragma mark - Collection View
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _bookIdStrArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShelfTVCCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *bookIdStr = [_bookIdStrArray objectAtIndex:indexPath.row];
    cell.title.text = [manager.books objectForKey:bookIdStr];
    cell.cover.image = [_imageDic objectForKey:bookIdStr];
    if (cell.cover.image==nil) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"cover/%ds.jpg",[bookIdStr intValue]]];
            UIImage *im = [UIImage imageWithContentsOfFile:path];
            //opaque：NO 不透明
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(78, 117), NO, 0.0);
            [im drawInRect:CGRectMake(0, 0, 78, 117)];
            UIImage *other = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.cover.image = other;
                [_imageDic setObject:other forKey:bookIdStr];
            });
        });
    }
    return cell;
}


//- (BOOL)collectionView:(UIcollectionView *)collectionView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"showLocalFile"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:(ShelfTVCCellCollectionViewCell*)sender];

        LocalFileVC *vc = segue.destinationViewController;
        vc.bookIdStr = [_bookIdStrArray objectAtIndex:indexPath.row];
        vc.title = [manager.books objectForKey:vc.bookIdStr];
    }
}

@end
