/**
 * Created by jszh on 2020/6/8.
 */

'use strict';

import React, {Component} from 'react';
import {
    StyleSheet, View, requireNativeComponent,
} from 'react-native';
import PropTypes from 'prop-types';

const AMap = requireNativeComponent('AMap', null);

export default class AMapView extends Component {

    constructor() {
        super();
        this._onGetLocation = this._onGetLocation.bind(this);
        this._onGeocodeSearch = this._onGeocodeSearch.bind(this);
        this._onKeywordsSearch = this._onKeywordsSearch.bind(this);
        this._onAroundSearch = this._onAroundSearch.bind(this);
    }

    static propTypes = {
        //是否显示实时路况
        showTraffic: PropTypes.bool,
        //是否显示指南针
        showsCompass: PropTypes.bool,
        //缩放手势的开启和关闭
        zoomEnabled: PropTypes.bool,
        //拖动的开启和关闭
        scrollEnabled: PropTypes.bool,
        //获取当前位置信息
        onGetLocation: PropTypes.func,
        //地理编码查询名称
        GeoName: PropTypes.string,
        //地理编码查询结果回调
        onGeocodeSearch: PropTypes.func,
        //关键字检索城市
        KeywordsCity: PropTypes.string,
        //关键字检索名称
        KeywordsName: PropTypes.string,
        //关键字检索结果回调
        onKeywordsSearch: PropTypes.func,
        //周边检索名称
        AroundName: PropTypes.string,
        //周边检索结果回调
        onAroundSearch: PropTypes.func,
    };

    static defaultProps = {};

    _onGetLocation(event) {
        this.props.onGetLocation && this.props.onGetLocation(event.nativeEvent);
    }

    _onGeocodeSearch(event) {
        this.props.onGeocodeSearch && this.props.onGeocodeSearch(event.nativeEvent);
    }

    _onKeywordsSearch(event) {
        this.props.onKeywordsSearch && this.props.onKeywordsSearch(event.nativeEvent);
    }

    _onAroundSearch(event) {
        this.props.onAroundSearch && this.props.onAroundSearch(event.nativeEvent);
    }

    render() {
        return (
            <AMap
                {...this.props}
                onGetLocation={this._onGetLocation}
                onGeocodeSearch={this._onGeocodeSearch}
                onKeywordsSearch={this._onKeywordsSearch}
                onAroundSearch={this._onAroundSearch}
            />
        );
    }
}
