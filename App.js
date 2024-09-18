import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';

import SQLite from 'react-native-sqlite-2'

const db = SQLite.openDatabase('test.db', '1.0', '', 1)

console.log(db)

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Open up App.js to start working on your app!</Text>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
