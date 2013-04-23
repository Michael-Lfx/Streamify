//
//  SFSettingsManageEffectsViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSettingsManageEffectsViewController.h"

@interface SFSettingsManageEffectsViewController ()

@property (nonatomic, strong) NSMutableArray *effects;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation SFSettingsManageEffectsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.effects = [NSMutableArray arrayWithArray:[[SFStorageManager sharedInstance] getAllEffectFiles]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Manage Effects";
    self.contentSizeForViewInPopover =  CGSizeMake(480, 380);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDelegate


# pragma mark - UITableSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.effects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SFEffectCellIdentifier = @"SFEffectCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SFEffectCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SFEffectCellIdentifier];
    }
    
    SFEffect *effect = [self.effects objectAtIndex:indexPath.row];
    cell.textLabel.text = effect.effectName;
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kSFSongTableViewCellRowHeight;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.effects removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
