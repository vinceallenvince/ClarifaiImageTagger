//
//  TagsViewController.h
//  ImageTagger
//
//  Created by Vince Allen on 8/24/15.
//  Copyright (c) 2015 Vince Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsViewController : UITableViewController
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *itemKey;
@end
