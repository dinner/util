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
+(NSString*)dateToString:(NSDate *)date format:(NSString*)format;//按格式将日期转字符串
+(NSString*)timeStampToDateString:(double)timeStampval;//时间戳转日期
+(NSString*)urlEncode:(NSString*)str;//
+(NSString *) md5: (NSString *) inPutText;//计算md5值

//+(NSArray*)analysisTextToArray:(NSString *)atstring;//将文本解析
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;//图片缩放
+(UIImage *)normalizedImage:(UIImage*)image;
+(UIImage*)imageFromBase64Str:(NSString*)baseStr;//图片base64转码

+(void)showTheMbprogressView:(NSString*)str view:(UIView*)view;//展示提示框
+(void)showTheMbprogressView:(NSString*)str view:(UIView*)view block:(void(^)())b;//展示提示框
+(void)clearUserInfo;

+(BOOL)isPassContainLetterAndNumber:(NSString*)pass;//字符串中是否包含字符和数字
+(BOOL)isIdentifier:(NSString*)identityCard;//验证是否身份证号码
+(BOOL)validatePhone:(NSString *)phone;//验证是否手机号
+(BOOL)checkCardNo:(NSString*) cardNo;//验证是否为正确的卡号
+(BOOL)luhmCheck:(NSString*)cardNum;//

+(NSDictionary*)createDic:(NSArray*)keys values:(NSArray*)val;
+(UIViewController*) currentViewController;//获取当前vc

@end
