//
//  LocalFileVC.m
//  FinalReader
//
//  Created by 武鸿帅 on 15/4/28.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "LocalFileVC.h"
#import "ViewController.h"
#import "VolumeManager.h"
@interface LocalFileVC ()
@property(nonatomic,strong) NSArray *volumeArray;
@end

@implementation LocalFileVC
{
    VolumeManager *manager;
}
static NSString *identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [VolumeManager defaultManager];
    _volumeArray = [[manager.volumes objectForKey:_bookIdStr] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _volumeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSString *key = [_volumeArray objectAtIndex:indexPath.row];
    NSString *name = [manager.volumeInfo objectForKey:key];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    cell.textLabel.text = name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [_volumeArray objectAtIndex:indexPath.row];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingString:[NSString stringWithFormat:@"/localfiles/%@",key]];
//    NSLog(@"%@",path);
    ViewController *vc = [[ViewController alloc] init];
    vc.path = path;
    vc.isHidden=YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *volumeIdStr = [_volumeArray objectAtIndex:indexPath.row];
        [manager removeVolume:volumeIdStr InBook:_bookIdStr];
        _volumeArray = [[manager.volumes objectForKey:_bookIdStr] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
