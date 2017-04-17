//
//  util.h
//  videoPro
//
//  Created by zhanglingxiang on 15/10/9.
//  Copyright (c) 2015年 zhanglingxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface util : NSObject


+(NSString*)dateToString:(NSDate*)date;//日期转字符串
+(NSString*)dateToString:(NSDate *)date format:(NSString*)format;
+(NSString*)timeStampToDateString:(double)timeStampval;//

+(NSArray*)analysisTextToArray:(NSString *)atstring;//将文本解析
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;//图片缩放
+(void)showTheMbprogressView:(NSString*)str view:(UIView*)view;
+(void)showTheMbprogressView:(NSString*)str view:(UIView*)view block:(void(^)())b;
+(NSDictionary*)createDic:(NSArray*)keys values:(NSArray*)val;

+(UIImage*)imageFromBase64Str:(NSString*)baseStr;

+(NSString*)urlEncode:(NSString*)str;
+(void)clearUserInfo;
+(BOOL)isPassContainLetterAndNumber:(NSString*)pass;
+(UIViewController*) currentViewController;
+(UIImage *)normalizedImage:(UIImage*)image;

+(NSString *) md5: (NSString *) inPutText;

+(BOOL)isIdentifier:(NSString*)identityCard;
+(BOOL)validatePhone:(NSString *)phone;

+(BOOL) checkCardNo:(NSString*) cardNo;//判断是否为正确的卡号
+(BOOL)luhmCheck:(NSString*)cardNum;

@end
