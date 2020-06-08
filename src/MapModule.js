/**
 * Created by jszh on 2020/6/8.
 */

'use strict';

import React, {PureComponent} from 'react';
import {
    StyleSheet, View,
} from 'react-native';

class MapModule extends PureComponent {
    constructor(props) {
        super(props);
        this.state = {};
    }

    render() {
        return (
            <View style={styles.container}>

            </View>
        );
    }

    componentDidMount() {

    }

    componentWillUnmount() {

    }

}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
});

export default MapModule;
