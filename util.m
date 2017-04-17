//
//  util.m
//  videoPro
//
//  Created by zhanglingxiang on 15/10/9.
//  Copyright (c) 2015年 zhanglingxiang. All rights reserved.
//

#define font [UIFont systemFontOfSize:12]
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

#import "util.h"
#import "MBProgressHUD.h"

#import "CommonCrypto/CommonDigest.h"
#import "singleInfo.h"

@implementation util


+(NSString*)dateToString:(NSDate*)date{
    if ([util isToday:date]) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"今天 HH:mm"];
        NSString *dateString = [format stringFromDate:date];
        return dateString;
    }
    if ([util isYestoday:date]) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"昨天 HH:mm"];
        NSString *dateString = [format stringFromDate:date];
        return dateString;
    }
    else{
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM-dd HH:mm"];
        NSString *dateString = [format stringFromDate:date];
        return dateString;
    }
}

+(NSString*)dateToString:(NSDate *)date format:(NSString*)strFormat{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:strFormat];
    NSString* strDate = [format stringFromDate:date];
    return strDate;
}

+(NSString*)timeStampToDateString:(double)timeStampval{
//    double timeStampval = [[dic objectForKey:@"publishtime"] doubleValue]/1000;
    NSTimeInterval timeStamp = (NSTimeInterval)timeStampval;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString* strDate = [util dateToString:date];
    return strDate;
}

//判断某日期是否是今天
+(BOOL)isToday:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents* selfCmps = [calendar components:unit fromDate:date];
    if (nowCmps.day == selfCmps.day) {
        return YES;
    }
    return NO;
}

//判断日期是否为昨天
+(BOOL)isYestoday:(NSDate*)date{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate* yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * dateString = [[date description] substringToIndex:10];
    if ([dateString isEqualToString:yesterdayString]) {
        return YES;
    }
    else{
        return NO;
    }
}


//将文本解析
+(NSArray*)analysisTextToArray:(NSString *)atstring
{
    if (!atstring.length)
    {
        return nil;
    }
    NSMutableArray* array = [NSMutableArray array];
    int indexBegin = 0;
    BOOL isBegin = NO;
    for (int i = 0;i < atstring.length;i++) {
        NSString *s = [atstring substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:@"["]) {
            if (!isBegin) {
                isBegin = YES;
                if (indexBegin != i) {
                    NSString* arrayOb = [atstring substringWithRange:NSMakeRange(indexBegin, i-indexBegin)];
                    indexBegin = i;
                    [array addObject:arrayOb];
                }
                indexBegin = i;
            }
            else{
                continue;
            }
        }
        else if([s isEqualToString:@"]"]){
            if (isBegin) {
                isBegin = NO;
                NSString* arrayOb = [atstring substringWithRange:NSMakeRange(indexBegin, i-indexBegin+1)];
                indexBegin = i+1;
                [array addObject:arrayOb];
            }
            else{
                continue;
            }
        }
        if (i == atstring.length-1) {
            if (indexBegin <= i) {
                NSString* arrayOb = [atstring substringWithRange:NSMakeRange(indexBegin, i-indexBegin+1)];
                [array addObject:arrayOb];
            }
        }
    }
    NSLog(@"%@",array);
    return array;
}



//图片缩放
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

+(void)showTheMbprogressView:(NSString*)str view:(UIView*)view{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.yOffset = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelFont = [UIFont systemFontOfSize:13];
    hud.detailsLabelText = str;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
        return;
    }];
}

+(void)showTheMbprogressView:(NSString*)str view:(UIView*)view block:(void(^)())b{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.yOffset = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelFont = [UIFont systemFontOfSize:13];
    hud.detailsLabelText = str;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
        if (b != nil) {
            b();
        }
        return;
    }];
}

+(NSDictionary*)createDic:(NSArray*)keys values:(NSArray*)val{
    NSDictionary* dic = [NSDictionary dictionaryWithObjects:val forKeys:keys];
    return dic;
}

+(UIImage*)imageFromBase64Str:(NSString*)baseStr{
    NSData* data = [baseStr dataUsingEncoding:NSUTF8StringEncoding];
    UIImage* image = [UIImage imageWithData:data];
    return image;
}

+(NSString*)urlEncode:(NSString*)str;{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+(void)clearUserInfo;{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
    [singleInfo infoClear];
}

+(BOOL)isPassContainLetterAndNumber:(NSString*)pass{
    BOOL containLetter = NO;
    BOOL containNumber = NO;
    for(int i = 0;i < pass.length;i++){
        unichar c = [pass characterAtIndex:i];
        if (c >= '0' && c <= '9') {
            containNumber = YES;
        }
        if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
            containLetter = YES;
        }
    }
    if (containLetter == YES && containNumber == YES) {
        return YES;
    }
    return NO;
}

+(UIViewController*) findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+(UIViewController*) currentViewController {
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [util findBestViewController:viewController];
}

+(UIImage *)normalizedImage:(UIImage*)image{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

+(NSString *) md5: (NSString *) inPutText
{
    /*
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    */
    //要进行UTF8的转码
    
    inPutText = [inPutText lowercaseString];//转为小写
    const char* input = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

//是否正确的身份证号码
+(BOOL)isIdentifier:(NSString*)identityCard{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}
//验证手机号
+ (BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
//是否为正确的卡号
+(BOOL) checkCardNo:(NSString*) cardNo{
    if ((int)cardNo.length < 13 || (int)cardNo.length > 19) return NO;
    NSString *str = [cardNo substringWithRange:NSMakeRange(0, cardNo.length - 1)];
    int luhmSum = 0;
    for(int i = (int)str.length - 1, j = 0; i >= 0; i--, j++) {
        int k = [str characterAtIndex:i] - '0';
        if(j % 2 == 0) {
            k *= 2;
            k = k / 10 + k % 10;
        }
        luhmSum += k;
    }
    char bit = (luhmSum % 10 == 0) ? '0' : (char)((10 - luhmSum % 10) + '0');
    if(bit == 'N'){
        return false;
    }
    return [cardNo characterAtIndex:cardNo.length - 1] == bit;
}

+(BOOL)luhmCheck:(NSString*)cardNum{
    
    NSString * lastNum = [[cardNum substringFromIndex:(cardNum.length-1)] copy];//取出最后一位
    
    NSString * forwardNum = [[cardNum substringToIndex:(cardNum.length -1)] copy];//前15或18位
    
    
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<forwardNum.length; i++) {
        
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        
        [forwardArr addObject:subStr];
        
    }
    
    
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i =(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        
        [forwardDescArr addObject:forwardArr[i]];
        
    }
    
    
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    
    
    for (int i=0; i< forwardDescArr.count; i++) {
        
        NSInteger num = [forwardDescArr[i] intValue];
        
        if (i%2) {//偶数位
            
            [arrEvenNum addObject:[NSNumber numberWithInt:num]];
            
        }else{//奇数位
            
            if (num * 2 < 9) {
                
                [arrOddNum addObject:[NSNumber numberWithInt:num * 2]];
                
            }else{
                
                NSInteger decadeNum = (num * 2) / 10;
                
                NSInteger unitNum = (num * 2) % 10;
                
                [arrOddNum2 addObject:[NSNumber numberWithInt:unitNum]];
                
                [arrOddNum2 addObject:[NSNumber numberWithInt:decadeNum]];
                
            }
            
        }
        
    }
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    NSInteger lastNumber = [lastNum integerValue];
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    return (luhmTotal%10 ==0)?YES:NO;
}

@end
