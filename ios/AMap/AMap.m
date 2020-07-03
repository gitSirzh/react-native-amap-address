//
//  AMap.m
//  Pods
//
//  Created by jszh on 2020/6/8.
//

#import "AMap.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AMap()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI * _search;//搜索对象
}
@property (nonatomic ,strong) MAUserLocation *currentLocation;
@property (nonatomic) BOOL showLocationPoint;
//@property (nonatomic ,strong) UIView *centerView;

@end

@implementation AMap

#pragma mark ------- 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initMapView];
//        [self initCenterView];
    }
    return self;
}

#pragma mark 创建打点
//- (void)initCenterView{
//    _centerView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 30)/2, (_mapView.frame.size.height - 30)/2, 30, 30)];
//    _centerView.backgroundColor = [UIColor redColor];
//    [self addSubview:_centerView];
//}

#pragma mark 创建地图
- (void)initMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
    _mapView.delegate = self;

    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];//跟随用户位置移动，并将定位点设置成地图中心点
    [_mapView setZoomLevel:17 animated:YES];//改变地图的缩放级别 范围：3～19


    [_mapView setMapType:MAMapTypeStandard];//标准地图
    [self addSubview:_mapView];
    [self initSearch];
    //发起周边搜索
    [self aroundSearchPOIWith:@""];
}

#pragma mark serach初始化
- (void)initSearch
{
    _search =[[AMapSearchAPI alloc] init];
    _search.delegate=self;
}

#pragma mark -------- set方法
- (void)setShowTraffic:(BOOL)showTraffic
{
    _showTraffic = showTraffic;
    _mapView.showTraffic = self.showTraffic;
}
- (void)setShowsCompass:(BOOL)showsCompass
{
    _showsCompass = showsCompass;
    _mapView.showsCompass = self.showsCompass;
}
- (void)setZoomEnabled:(BOOL)zoomEnabled
{
    _zoomEnabled = zoomEnabled;
    _mapView.zoomEnabled = self.zoomEnabled;
}
- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    _mapView.scrollEnabled = self.scrollEnabled;
}
- (void)setCurrentLocation:(MAUserLocation *)currentLocation
{
    _currentLocation = currentLocation;
    [self reGeoCoding];
}
- (void)setGeoName:(NSString *)GeoName
{
    _GeoName = GeoName;
    if (!self.onGeocodeSearch) {
        return;
    }
    [self GeocodeSearchWith:self.GeoName];
    self.onGeocodeSearch(@{
        @"message":@"成功",
                         });
}

- (void)setKeywordsName:(NSString *)KeywordsName
{
    _KeywordsName = KeywordsName;
    if (!self.onKeywordsSearch) {
        return;
    }
    [self KeywordsSearchPOIWithCity:self.KeywordsCity andKeywords:self.KeywordsName];
    self.onKeywordsSearch(@{
        @"message":@"成功",
                          });
}

- (void)setKeywordsCity:(NSString *)KeywordsCity
{
    _KeywordsCity = KeywordsCity;
    if (!self.onKeywordsSearch) {
        return;
    }
    [self KeywordsSearchPOIWithCity:self.KeywordsCity andKeywords:self.KeywordsName];
    self.onKeywordsSearch(@{
        @"message":@"成功",
                          });
}

- (void)setAroundName:(NSString *)AroundName
{
    _AroundName = AroundName;
    if (!self.onAroundSearch) {
        return;
    }
    [self aroundSearchPOIWith:self.AroundName];
}

#pragma mark ------- 地理编码查询
- (void)GeocodeSearchWith:(NSString *)name
{
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = name;
    [_search AMapGeocodeSearch:geo];
}

#pragma mark ------- 地理编码查询回调
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0){
        return;
    }
    NSMutableArray *annotations = [NSMutableArray array];
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        [annotations addObject:[self GeocodeAnnotationWith:obj]];
    }];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:annotations];
}

- (MAPointAnnotation*)GeocodeAnnotationWith:(AMapGeocode*)obj
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    AMapGeoPoint *point = obj.location;
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
    pointAnnotation.title = obj.formattedAddress;
    return pointAnnotation;
}


#pragma mark -------- 逆地理编码
- (void)reGeoCoding{
    if (_currentLocation.location) {
        AMapReGeocodeSearchRequest *request =[[AMapReGeocodeSearchRequest alloc] init];
        request.location =[AMapGeoPoint locationWithLatitude:_currentLocation.location.coordinate.latitude longitude:_currentLocation.location.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
    }
}

#pragma mark -------- 逆地理编码失败回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    if (!self.onGetLocation) {
        return;
    }
    self.onGetLocation(@{
        @"message":@"失败",
        @"error":error.domain,
                       });
}

#pragma mark ------- 逆地理编码查询成功回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    //我们把编码后的地理位置，显示到 大头针的标题和子标题上
    NSString *title =response.regeocode.addressComponent.city;
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    _mapView.userLocation.title = title;
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    if (!self.onGetLocation) {
        return;
    }
    self.onGetLocation(@{
        @"message":@"成功",
        @"latitude": @(_mapView.userLocation.coordinate.latitude),
        @"longitude": @(_mapView.userLocation.coordinate.longitude),
        @"title":title,
        @"subtitle":response.regeocode.formattedAddress,
                       });
}

#pragma mark ---- 关键字检索
- (void)KeywordsSearchPOIWithCity:(NSString *)city andKeywords:(NSString *)keywords
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    if (![city isEqualToString:@""]) {
        request.city = city;
    }
    request.keywords = keywords;
    request.requireExtension = YES;
    // 搜索SDK v3.2.0 新增加的功能，只搜索本城市的POI
    request.cityLimit = YES;
    request.requireSubPOIs = YES;
    [_search AMapPOIKeywordsSearch:request];
}

#pragma mark ----------- 周边检索
- (void)aroundSearchPOIWith:(NSString *)keywords
{
    if (_currentLocation == nil || _search == nil) {
        return;
    }
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.location.coordinate.latitude longitude:_currentLocation.location.coordinate.longitude];
    request.keywords = keywords;
    request.sortrule = 0;
    request.requireExtension = YES;
    [_search AMapPOIAroundSearch:request];
}

#pragma mark ----------- POI 搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0){
        return;
    }
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        [poiAnnotations addObject:[self POIAnnotationWith:obj]];
    }];
    //移除上次周边标注
//    [_mapView removeAnnotations:_mapView.annotations];
    //取出搜索到的POI（POI：Point Of Interest）
    NSMutableArray *cityArray = [NSMutableArray new];
    for (AMapPOI *poi in response.pois) {
        NSString *name = poi.name; //地名
        NSString *address = poi.address; //全部地址
        NSString *type = poi.type; //类型：酒店、公共场所等
        NSString *city = poi.city; //所在城市
        NSString *district = poi.district; //所在地区
        [cityArray addObject:@{
            @"name": name,
            @"address": address,
            @"type": type,
            @"city": city,
            @"district": district,
        }];
    }
    self.onAroundSearch(@{@"aroundArray":cityArray});
    // 将结果以annotation的形式加载到地图上
//    [_mapView addAnnotations:poiAnnotations];
}

- (MAPointAnnotation*)POIAnnotationWith:(AMapPOI*)obj
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    AMapGeoPoint *point = obj.location;
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
    pointAnnotation.title = obj.name;
    return pointAnnotation;
}

#pragma mark 定位更新回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation){
        //取出当前位置的坐标
        self.currentLocation = userLocation;
    }
}

- (void)dealloc
{
    _mapView = nil;
    _mapView.delegate = nil;
    _search = nil;
}


@end
