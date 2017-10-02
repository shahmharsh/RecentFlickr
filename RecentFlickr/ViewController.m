//
//  ViewController.m
//  RecentFlickr
//
//  Created by Harsh Shah on 9/29/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"
#import "RFPhotosManager.h"
#import "RFPhoto.h"

static NSString * const kThumbnailIdentifier = @"thumbnailIdentifier";
static NSString * const kFooterIdentifier = @"footerIdentifier";
static const NSInteger kImageViewTag = 100;

@interface ViewController ()
@property (nonatomic, strong) NSArray<RFPhoto *> *photos;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [RFPhotosManager sharedManager].allPhotos;
    if (!self.photos.count) {
        [self fetchMorePhotos];
    }
}

-(void)fetchMorePhotos
{
    __weak typeof (self) weakSelf = self;
    [[RFPhotosManager sharedManager] fetchMorePhotosWithCompletion:^(NSArray<RFPhoto *> * _Nonnull photos, NSError * _Nonnull error) {
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showError:error];
            });
            return;
        }
        
        strongSelf.photos = photos;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.collectionView reloadData];
        });
    }];
}

-(void)showError:(NSError *)error
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Something went wrong"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Retry"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self fetchMorePhotos];
                                                          }];
    [alert addAction:defaultAction];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.photos.count - 1) {
        [self fetchMorePhotos];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kThumbnailIdentifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
    RFPhoto *photo = [self.photos objectAtIndex:indexPath.row];
    [imageView sd_setImageWithURL:photo.thumbnailUrl];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterIdentifier forIndexPath:indexPath];
        if ([RFPhotosManager sharedManager].allPhotosFetched) {
            reusableview.hidden = YES;
        }
    }
    return reusableview;
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize = CGSizeMake(100, 100);
    return mElementSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
     return UIEdgeInsetsMake(0,8,0,8);
}

@end
