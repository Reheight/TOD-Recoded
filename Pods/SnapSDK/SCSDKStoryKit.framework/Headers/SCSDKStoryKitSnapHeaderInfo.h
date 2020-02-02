/**
 * This file is generated using the remodel generation script.
 * The name of the input file is SCSDKStoryKitSnapHeaderInfo.value
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCSDKStoryKitSnapHeaderInfo : NSObject <NSCopying, NSCoding>

@property (nonatomic, readonly, copy) UIImage *image;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;

@end

