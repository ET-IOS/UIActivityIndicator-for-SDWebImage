//
//  UIImageView+UIActivityIndicatorForSDWebImage.m
//  UIActivityIndicator for SDWebImage
//
//  Created by Giacomo Saccardo.
//  Copyright (c) 2014 Giacomo Saccardo. All rights reserved.
//

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <objc/runtime.h>

static char TAG_ACTIVITY_INDICATOR;
static char CONSTRAINTS_ACTIVITY_INDICATOR;

@interface UIImageView (Private)

-(void)addActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle) activityStyle;

@end

@implementation UIImageView (UIActivityIndicatorForSDWebImage)

@dynamic activityIndicator;

- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

-(NSArray *)activityIndicatorLayoutConstraints {
    return (NSArray *)objc_getAssociatedObject(self, &CONSTRAINTS_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicatorLayoutConstraints:(NSArray *)constraints {
    objc_setAssociatedObject(self, &CONSTRAINTS_ACTIVITY_INDICATOR, constraints, OBJC_ASSOCIATION_RETAIN);
}


- (void)addActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)activityStyle {
    
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityStyle];
        
        [self updateActivityIndicatorFrame];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self addSubview:self.activityIndicator];
                        
            if(self.activityIndicator) {
                if (@available(iOS 6.0, *)) {
                    
                    NSArray * array = [self activityIndicatorLayoutConstraints];
                    if(array.count > 0){
                        [self removeConstraints:array];
                    }
                    
                    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
                    NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
                    NSLayoutConstraint * centery = [NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
                    
                    [self addConstraints:@[centerX,centery]];
                    [self setActivityIndicatorLayoutConstraints:@[centerX,centery]];
                }
            }
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.activityIndicator startAnimating];
    });
    
}

-(void)updateActivityIndicatorFrame {
//    if (self.activityIndicator) {
//        CGRect activityIndicatorBounds = self.activityIndicator.bounds;
//        float x = (self.frame.size.width - activityIndicatorBounds.size.width) / 2.0;
//        float y = (self.frame.size.height - activityIndicatorBounds.size.height) / 2.0;
//        self.activityIndicator.frame = CGRectMake(x, y, activityIndicatorBounds.size.width, activityIndicatorBounds.size.height);
//    }
}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];

    [self updateActivityIndicatorFrame];
}

#pragma mark - Methods

- (void)setImageWithURL:(NSURL *)url usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStye {
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil usingActivityIndicatorStyle:activityStye];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock usingActivityIndicatorStyle:activityStyle];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    
    [self addActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
         placeholderImage:placeholder
                  options:options
                 progress:progressBlock
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                    if (completedBlock) {
                        completedBlock(image, error, cacheType, imageUrl);
                    }
                    [weakSelf removeActivityIndicator];
                }
     ];
}

@end
