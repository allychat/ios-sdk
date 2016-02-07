//
//  ACPagingModel.h
//  ACSDK
//
//  Created by Andrew Kopanev on 12/23/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACBaseModel.h"

@interface ACPagingModel : ACBaseModel

// could be ACRoomModel, ACMessageModel or ACUserModel objects
@property (nonatomic, readonly) NSArray             *models;
@property (nonatomic, assign, readonly) NSInteger   count;

@end
