/**
 * Created by jszh on 2020/6/8.
 */

'use strict';

import React, {Component} from 'react';
import {
    StyleSheet, View, requireNativeComponent,
} from 'react-native';

const AmapView = requireNativeComponent('AmapView');

class MapView extends Component {
    constructor(props) {
        super(props);
        this.state = {};
    }

    render() {
        return (
            <AmapView
                style={[styles.container, this.props.style]}
            />
        );
    }

}

const styles = StyleSheet.create({
    container: {
        width: '100%',
        height: 300,
    },
});

export default MapView;
