//
//  SFConstants.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#ifndef Streamify_SFConstants_h
#define Streamify_SFConstants_h

#define kSHOWCASE_MODE (0)

#define kSFCanvasTitleFrameXInHomeView 750
#define kSFCanvasTitleFrameYInHomeView 100
#define kSFCanvasFrameXInHomeView 120
#define kSFCanvasFrameYInHomeView 170
#define kSFTopbarFrameXInHomeView 250
#define kSFTopbarFrameYInHomeView 0

#define kSFSearchBarFrameXHiddenInHomeView 90
#define kSFSearchBarFrameYHiddenInHomeView 100
#define kSFSearchBarFrameWHiddenInHomeView 0
#define kSFSearchBarFrameHHiddenInHomeView 40

#define kSFSearchBarFrameXShownInHomeView 150
#define kSFSearchBarFrameYShownInHomeView 100
#define kSFSearchBarFrameWShownInHomeView 320
#define kSFSearchBarFrameHShownInHomeView 40

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

#define kSFChatTableCellFrameW 440
#define kSFChatTableCellFrameHDefault 60

#define kSFChatTableCellAvatarX 10
#define kSFChatTableCellAvatarY 8
#define kSFChatTableCellAvatarW 44
#define kSFChatTableCellAvatarH 44

#define kSFChatTableCellUserNameFrameX 66
#define kSFChatTableCellUserNameFrameY 6
#define kSFChatTableCellUserNameFrameW 365
#define kSFChatTableCellUserNameFrameH 21

#define kSFChatTableCellMessageFrameX 66
#define kSFChatTableCellMessageFrameY 27
#define kSFChatTableCellMessageFrameW 365
#define kSFChatTableCellMessageFrameHDefault 27

#define kSFKeyboardHeight 352
#define kSFScreenHeight 768

#define kSFStreamifyPlaylistViewFrameXInPlaylistManagerView 552
#define kSFStreamifyPlaylistViewFrameYInPlaylistManagerView 0
#define kSFLibraryPlaylistViewFrameXInPlaylistManagerView 80
#define kSFLibraryPlaylistViewFrameYInPlaylistManagerView 0

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
    kSFRecentBrowsing,
    kSFSearchBrowsing
} SFHomeBrowsingType;

typedef enum {
    kSFPlayingOrRecordingState,
    kSFStoppedOrPausedState
} SFChannelState;

// NOTIFICATIONS
#define kUpdateMeSuccessNotification @"updateMeSuccess"
#define kUpdateLiveChannelsSuccessNotification @"updateLiveChannelsSuccess"
#define kSFAudioStreamerDidFinish @"audioStreamerDidFinish"
#define kSFAudioStreamerDidStart @"audioStreamerDidStart"

#define kOperationResult @"Operation_Result"
#define kOperationError @"Operation_Error"
#define OPERATION_SUCCEEDED @"Operation_Succeeded"
#define OPERATION_FAILED @"Operation_Failed"

#define kResultLiveChannels @"ResultLiveChannels"

// Chating function
#define kMessageChannel @"channel"
#define kMessageText @"text"
#define kMessageName @"name"
#define kMessagePictureURL @"pictureURL"
#define kMessageTime @"createdAt"
#define kMessageFetchingLimit 20
#define kResultNewMessages @"NewMessages"
#define kResultMessage @"ResultMessage"

#define kResultFollowers @"ResultFollowers"
#define kResultFollowing @"ResultFollowing"
#define kResultAllUsers @"ResultAllUsers"
#define kResultUsers @"ResultUsers"
#define kResultNumberOfFollowers @"ResultNumberOfFollowers"
#define kResultNumberofLsiteners @"ResultNumberOfListeners"

#define kResultJSON @"ResultJSON"

// Storage Keys
#define kSFStoragePlaylist @"StoragePlaylist"

// Image
#define kSFSongAlbumCoverImageHolder @"no_artwork.png"


#endif
