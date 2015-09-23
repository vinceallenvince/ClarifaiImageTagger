#import <Foundation/Foundation.h>

@interface Tag : NSObject
@property (nonatomic, strong) NSString *name;
- (instancetype)initWithName: (NSString *)name;
@end
