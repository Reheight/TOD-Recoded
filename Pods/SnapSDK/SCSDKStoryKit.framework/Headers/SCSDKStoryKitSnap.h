/**
 * This file is generated using the remodel generation script.
 * The name of the input file is SCSDKStoryKitSnap.adtValue
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCSDKStoryKitSnapInfo.h"
#import "SCSDKStoryKitSnapHeaderInfo.h"
#import "SCSDKStoryKitSnapVideoInfo.h"
#import "SCSDKStoryKitSnapImageInfo.h"

typedef void (^SCSDKStoryKitSnapVideoMatchHandler)(SCSDKStoryKitSnapInfo *snapInfo, SCSDKStoryKitSnapVideoInfo *videoInfo, SCSDKStoryKitSnapHeaderInfo *headerInfo);
typedef void (^SCSDKStoryKitSnapImageMatchHandler)(SCSDKStoryKitSnapInfo *snapInfo, SCSDKStoryKitSnapImageInfo *imageInfo, SCSDKStoryKitSnapHeaderInfo *headerInfo);

@interface SCSDKStoryKitSnap : NSObject <NSCopying, NSCoding>

+ (instancetype)imageWithSnapInfo:(SCSDKStoryKitSnapInfo *)snapInfo imageInfo:(SCSDKStoryKitSnapImageInfo *)imageInfo headerInfo:(SCSDKStoryKitSnapHeaderInfo *)headerInfo
NS_SWIFT_NAME(image(snapInfo:imageInfo:headerInfo:));

+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)videoWithSnapInfo:(SCSDKStoryKitSnapInfo *)snapInfo videoInfo:(SCSDKStoryKitSnapVideoInfo *)videoInfo headerInfo:(SCSDKStoryKitSnapHeaderInfo *)headerInfo
NS_SWIFT_NAME(video(snapInfo:videoInfo:headerInfo:));

- (instancetype)init NS_UNAVAILABLE;

- (void)matchVideo:(SCSDKStoryKitSnapVideoMatchHandler)videoMatchHandler image:(SCSDKStoryKitSnapImageMatchHandler)imageMatchHandler;

@end

