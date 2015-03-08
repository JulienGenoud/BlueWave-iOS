//
//  HistoryViewController.m
//  BlueWave
//
//  Created by Rémi Hillairet on 28/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCollectionViewCell.h"
#import "DetailsViewController.h"
#import "Define.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *notSeeButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineCenter;
@property (weak, nonatomic) IBOutlet UICollectionView *historyCollectionView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIFont *font = [UIFont fontWithName:@"DINPro-Black" size:14.0];
    [self.allButton.titleLabel setFont:font];
    self.underlineCenter.constant = [UIScreen mainScreen].bounds.size.width / 2 - self.allButton.center.x;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deselectButtons {
    UIFont *font = [UIFont fontWithName:@"DINPro-Medium" size:14.0];
    [self.allButton.titleLabel setFont:font];
    [self.notSeeButton.titleLabel setFont:font];
    [self.favoriteButton.titleLabel setFont:font];
}

- (IBAction)showAllAction:(id)sender {
    [self deselectButtons];
    UIFont *font = [UIFont fontWithName:@"DINPro-Black" size:14.0];
    [self.allButton.titleLabel setFont:font];
    self.underlineCenter.constant = [UIScreen mainScreen].bounds.size.width / 2 - self.allButton.center.x;
}

- (IBAction)showNotSeeAction:(id)sender {
    [self deselectButtons];
    UIFont *font = [UIFont fontWithName:@"DINPro-Black" size:14.0];
    [self.notSeeButton.titleLabel setFont:font];
    self.underlineCenter.constant = [UIScreen mainScreen].bounds.size.width / 2 - self.notSeeButton.center.x;
}

- (IBAction)showFavoriteAction:(id)sender {
    [self deselectButtons];
    UIFont *font = [UIFont fontWithName:@"DINPro-Black" size:14.0];
    [self.favoriteButton.titleLabel setFont:font];
    self.underlineCenter.constant = [UIScreen mainScreen].bounds.size.width / 2 - self.favoriteButton.center.x;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = @"Test";
    cell.layer.masksToBounds = NO;
    cell.layer.cornerRadius = 8; // if you like rounded corners
    cell.layer.shadowOffset = CGSizeMake(-5, 5);
    cell.layer.shadowRadius = 3;
    cell.layer.shadowOpacity = 0.3;
    
    cell.picture.layer.cornerRadius = 8;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsViewController *detailsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(self.historyCollectionView.frame.size.width / 2 - 20, 160);
    return size;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
