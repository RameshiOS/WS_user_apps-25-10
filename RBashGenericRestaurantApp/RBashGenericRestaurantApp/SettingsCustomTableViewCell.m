//
//  SettingsCustomTableViewCell.m
//  ThinkingCup
//
//  Created by Manulogix on 05/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "SettingsCustomTableViewCell.h"

@implementation SettingsCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
