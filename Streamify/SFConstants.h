//
//  SFConstants.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#ifndef Streamify_SFConstants_h
#define Streamify_SFConstants_h

#define kSFCanvasTitleFrameXInHomeView 700
#define kSFCanvasTitleFrameYInHomeView 100
#define kSFCanvasFrameXInHomeView 120
#define kSFCanvasFrameYInHomeView 170
#define kSFTopbarFrameXInHomeView 250
#define kSFTopbarFrameYInHomeView 0

#define kSFMainColumnFrameX 80
#define kSFMainColumnFrameY 0
#define kSFMainColumnFrameW 420
#define kSFMainColumnFrameH 768

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

// NOTIFICATIONS
#define kUpdateMeSuccessNotification @"updateMeSuccess"
#define kUpdateLiveChannelsSuccessNotification @"updateLiveChannelsSuccess"

#endif
