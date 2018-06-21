import React from 'react';
import { AppRegistry, StyleSheet, Text, View, ActivityIndicator } from 'react-native';

class RNAirQuality extends React.Component {
  render() {
    var contents;
    const readings = this.props['readings'];
    if (readings.length == 0) {
      contents = (
        <>
          <Text style={styles.centerLabel}>
            Looking for sensor...
            {'\n'}
          </Text>
          <ActivityIndicator size="large" color="#999999" />
        </>
      );
    } else {
      contents = readings.map((reading, index) => (
        <View style={styles.readings} key={index}>
          <Text style={styles.leftLabel} key={reading.name}>
            {reading.name}:
          </Text>
          <Text style={styles.rightLabel} key={reading.value}>
            {reading.value}
            {'\n'}
          </Text>
        </View>
      ));
    }
    return (
      <View style={styles.container}>
        <Text style={styles.title}>Air Quality</Text>
        {contents}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  centerLabel: {
    fontSize: 18,
    fontWeight: '400',
    textAlign: 'center',
    color: '#999999',
  },
  leftLabel: {
    fontWeight: '600',
    textAlign: 'left',
  },
  rightLabel: {
    fontFamily: 'Courier',
    textAlign: 'right',
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#EEEEEE',
  },
  title: {
    fontWeight: 'bold',
    fontSize: 30,
    textAlign: 'center',
    margin: 10,
  },
  readings: {
    fontSize: 20,
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
    width: 200,
    flexDirection: 'row',
    justifyContent: 'space-between'
  },
});

// Module name
AppRegistry.registerComponent('RNAirQuality', () => RNAirQuality);
