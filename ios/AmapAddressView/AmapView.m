//
//  AmapView.m
//
//  Created by jszh on 2020/06/08.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "AmapView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AmapView ()<MAMapViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) MAMapView *mapView;//地图视图
@property (nonatomic, strong) AMapLocationManager *locationManager;//定位管理者
@end

@implementation AmapView

RCT_EXPORT_MODULE();

- (UIView *)view{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _mapView.delegate = self;
        _mapView.mapType = MAMapTypeStandard;//设置地图类型
        _mapView.showTraffic= YES;//是否显示交通图
        [self.locationManager startUpdatingLocation];//开始定位
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];//定位以后改变地图的图层显示
        [_mapView setZoomLevel:16 animated:YES];//改变地图的缩放级别 范围：3～19

    }
    return _mapView;
}
- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (void)viewDidLoad {
    [self locationManager];
    [self mapView];
}
//AMapLocationManager代理方法位置更新以后回调。
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}
-(void) viewDidAppear:(BOOL)animated{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(31.982527, 118.735046);
    pointAnnotation.title = @"宏创科技";
    pointAnnotation.subtitle = @"国家广告产业园XXX";
    [self.mapView addAnnotation:pointAnnotation];
}
//MAMapView代理方法，用来设置大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id )annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil){
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES; //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES; //设置标注动画显示，默认为NO
        annotationView.draggable = YES; //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

@end
