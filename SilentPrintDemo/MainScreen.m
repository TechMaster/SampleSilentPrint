//
//  MainScreen.m
//  TechmasterApp
//
//  Created by techmaster on 9/7/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

#import "MainScreen.h"
#import "BootLogic.h"
@interface MainScreen () <UIAlertViewDelegate>

@end

@implementation MainScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}
- (void)setAbout:(NSString *)about {
    _about = [NSString stringWithFormat:@"%@\n\n%@", about, @"Written by Techmaster Vietnam Ltd"];
}

- (void)showAlert: (NSString*) title with: (NSString*) message {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle: title
                                message: message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [alert dismissViewControllerAnimated:true completion:nil];
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void) onAbout {
    [self showAlert:self.title with: self.about];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* menuSection = self.menu[section];
    
    return [menuSection[MENU] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary* menuSection = self.menu[section];
    return menuSection[SECTION];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary* menuSection = self.menu[indexPath.section];
    NSDictionary* menuItem = menuSection[MENU][indexPath.row];
    cell.textLabel.text = menuItem[TITLE];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* menuSection = self.menu[indexPath.section];
    NSDictionary* menuItem = menuSection[MENU][indexPath.row];
    NSString* xibClass = menuItem[CLASS];
    UIViewController* detailScreen;

    
    ////////////Trung Add: ///////////////
    NSRange range = [xibClass rangeOfString:@"#"];
    if (!(range.location == NSNotFound)) {
        NSString *stringStoryBoard = [xibClass substringFromIndex:range.location+1];
        xibClass = [xibClass substringToIndex:range.location];
        
        
        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:stringStoryBoard bundle:nil];
        
        detailScreen = [storyBoard instantiateViewControllerWithIdentifier:xibClass];
        detailScreen.title = menuItem[TITLE];
        [self.navigationController pushViewController:detailScreen animated:YES];
        return;
    }
    
    //////////////////////////////////
    
    
    
    
    if([[NSBundle mainBundle] pathForResource:xibClass ofType:@"nib"] != nil)
    {
        //If the xib file exists
        detailScreen = [(UIViewController*)[NSClassFromString(xibClass) alloc] initWithNibName:xibClass bundle:nil];
    } else {
        //If the xib file does not exist
        detailScreen = [NSClassFromString(xibClass) new];
    }
    detailScreen.title = menuItem[TITLE];
    
    if (detailScreen) {
        [self.navigationController pushViewController:detailScreen animated:YES];
    } else {
        //Warn if cannot initialize detailScreen
        [self showAlert:@"Warning"
                   with:[NSString stringWithFormat:@"Please implement screen %@", xibClass]];
    }
    
}


@end
