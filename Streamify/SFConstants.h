//
//  SFConstants.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#ifndef Streamify_SFConstants_h
#define Streamify_SFConstants_h

#define kSFCanvasTitleFrameXInHomeView 750
#define kSFCanvasTitleFrameYInHomeView 100
#define kSFCanvasFrameXInHomeView 120
#define kSFCanvasFrameYInHomeView 170
#define kSFTopbarFrameXInHomeView 250
#define kSFTopbarFrameYInHomeView 0

#define kSFMainColumnFrameX 80
#define kSFMainColumnFrameY 0
#define kSFMainColumnFrameW 420
#define kSFMainColumnFrameH 768

#define kSFChatViewFrameX 500
#define kSFChatViewFrameY 0
#define kSFChatViewFrameW 524
#define kSFChatViewFrameH 768

#define kSFChatTextFrameY 670
#define kSFChatTextFrameH 40

#define kSFChatTableFrameX 50
#define kSFChatTableFrameY 80
#define kSFChatTableFrameW 440
#define kSFChatTableFrameH 560

#define kSFKeyboardHeight 352
#define kSFScreenHeight 768

typedef enum {
    kSFSidebarFull,
    kSFSidebarBackOnly
} SFSidebarType;

typedef enum {
    kSFMainColumnListener,
    kSFMainColumnBroadcaster
} SFMainColumnType;

typedef enum {
    kSFTrendingBrowsing,
    kSFFavoriteBrowsing,
    kSFRecentBrowsing
} SFHomeBrowsingType;

typedef enum {
    kSFPlayingOrRecordingState,
    kSFStoppedOrPausedState
} SFChannelState;

// NOTIFICATIONS
#define kUpdateMeSuccessNotification @"updateMeSuccess"
#define kUpdateLiveChannelsSuccessNotification @"updateLiveChannelsSuccess"

#define kOperationResult @"Operation_Result"
#define OPERATION_SUCCEEDED @"Operation_Succeeded"
#define OPERATION_FAILED @"Operation_Failed"

#define kResultLiveChannels @"ResultLiveChannels"

#define kMessageChannel @"MessageChannel"
#define kMessageText @"MessageText"
#define kMessageTime @"MessageTime"

#define kResultFollowers @"ResultFollowers"
#define kResultFollowing @"ResultFollowing"

#endif
