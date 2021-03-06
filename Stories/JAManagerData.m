//
//  EMManagerData.m
//
//  Created by Antonin Langlade on 26/02/2014.
//  Copyright (c) 2014 Antonin Langlade. All rights reserved.
//

#import "JAManagerData.h"
#import "JAStorieModel.h"
#import "JAChapterModel.h"
#import "JAArticleModel.h"
#import "JAInfoModel.h"

@implementation JAManagerData

#pragma mark Singleton Methods

+ (id)sharedManager {
    static JAManagerData *myManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myManager = [[self alloc] init];

    });
    return myManager;
}

- (id)init {
    if (self = [super init]) {
        [self getDataFromJSON];
    }
    return self;
}
-(void)getDataFromJSON{
    // Get data
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stories" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Manager
    self.data = [[JAStoriesModel alloc] initWithString:jsonString error:nil];
}
-(NSUInteger)getNumberOfStories{
    return [[self.data stories] count];
}
-(NSUInteger)getNumberOfChapter:(NSInteger)storie{
    return [[[[self.data stories] objectAtIndex:storie]chapters]count];
}
-(NSUInteger)getNumberOfArticle:(NSInteger)storie chapter:(NSInteger)chapter{
    return [[[[[[self.data stories] objectAtIndex:storie]chapters] objectAtIndex:chapter] articles] count];
}
-(JAStorieModel*)getCurrentStorie{
    
    return [[self.data stories] objectAtIndex:self.currentStorie];
}

-(JAChapterModel*)getCurrentChapter{

    return [[[[self.data stories] objectAtIndex:self.currentStorie] chapters] objectAtIndex:self.currentChapter];
}

-(JAArticleModel*)getCurrentArticle{
    
    return [[[[[[self.data stories] objectAtIndex:self.currentStorie] chapters] objectAtIndex:self.currentChapter] articles] objectAtIndex:self.currentArticle];
}

-(JAInfoModel*)getCurrentInfo{
    return [[[[[[self.data.stories[self.currentStorie] chapters] objectAtIndex:self.currentChapter] articles] objectAtIndex:self.currentArticle] infos] objectAtIndex:self.currentInfo];
}

-(UIColor *)getCurrentColor {
    NSString *hexCode = [[[self.data stories] objectAtIndex:self.currentStorie] cover].color;
    return [UIColor pxColorWithHexValue:hexCode];
}

-(UIColor *)getCurrentTextColor {
    NSString *hexCode = [[[self.data stories] objectAtIndex:self.currentStorie] cover].textColor;
    return [UIColor pxColorWithHexValue:hexCode];
}

@end
