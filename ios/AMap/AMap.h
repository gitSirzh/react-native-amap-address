//
//  AMap.h
//  Pods
//
//  Created by jszh on 2020/6/8.
//

#import <UIKit/UIKit.h>

#import <MAMapKit/MAMapKit.h>
#import <React/RCTComponent.h>


@interface AMap : UIView

/**是否显示实时路况*/
@property (nonatomic, assign) BOOL showTraffic;
/**是否显示指南针*/
@property (nonatomic, assign) BOOL showsCompass;
/**缩放手势的开启和关闭*/
@property (nonatomic, assign) BOOL zoomEnabled;
/**拖动的开启和关闭*/
@property (nonatomic, assign) BOOL scrollEnabled;


/**获取当前位置信息*/
@property (nonatomic, copy) RCTBubblingEventBlock _Nonnull onGetLocation;

NS_ASSUME_NONNULL_BEGIN

/**地理编码查询名称*/
@property (nonatomic, strong) NSString *GeoName;
/**地理编码查询结果回调*/
@property (nonatomic, copy) RCTBubblingEventBlock _Nullable onGeocodeSearch;


/**关键字检索城市*/
@property (nonatomic, strong) NSString *KeywordsCity;
/**关键字检索名称*/
@property (nonatomic, strong) NSString *KeywordsName;
/**关键字检索结果回调*/
@property (nonatomic, copy) RCTBubblingEventBlock _Nonnull onKeywordsSearch;


/**周边检索名称*/
@property (nonatomic, strong) NSString *AroundName;
/**周边检索结果回调*/
@property (nonatomic, copy) RCTBubblingEventBlock _Nonnull onAroundSearch;

NS_ASSUME_NONNULL_END

@end
