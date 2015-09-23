#import "TagsViewController.h"
#import "Tag.h"
#import "ImageStore.h"

@interface TagsViewController ()
@property (strong, nonatomic) UIBarButtonItem *startOverButton;
@end

@implementation TagsViewController

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tags";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.startOverButton = [[UIBarButtonItem alloc] initWithTitle:@"Start Over"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(startOver)];
    
    self.navigationItem.leftBarButtonItem = self.startOverButton;
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[ImageStore sharedStore] imageForKey:self.itemKey]];

    self.tableView.tableHeaderView = imageView;

    NSIndexPath* ip = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)startOver
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    Tag *tag = self.tags[indexPath.row];
    cell.textLabel.text = tag.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.textLabel.font = [UIFont fontWithName:@"CircularTT-Bold" size:18];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];

    /*if (indexPath.row == 0) {
        UIImage *imageToDisplay =
        [cell.imageView setImage:imageToDisplay];
    }*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
