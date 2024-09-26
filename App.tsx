import { StatusBar } from 'expo-status-bar';
import { Platform } from 'react-native';
import { StyleSheet, Text, View, Button, Alert } from 'react-native';
import {
  multiply,
  bleServiceEvent,
  registerForNotifications,
  globalPropertyGetVirtualCardEnabled,
  globalPropertySetVirtualCardEnabled,
  libKeyCardGetAPIVersion,
} from 'react-native-esmart';
import { useQuery, QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useEffect } from 'react';

import SQLite from 'react-native-sqlite-2';

const db = SQLite.openDatabase('test.db', '1.0', '', 1);

console.log(db);

// Create a client
const queryClient = new QueryClient();

function Main() {
  const a = 2;
  const b = 3;

  const { data, error, isLoading } = useQuery({
    queryFn: () => multiply(a, b),
    queryKey: ['multiply', a, b],
  });

  // const {
  //   data: bleServiceEventData,
  //   error: bleServiceEventError,
  //   isLoading: bleServiceEventIsLoading,
  // } = useQuery({
  //   queryFn: async () => {
  //     const result = await bleServiceEvent();
  //     console.log('bleServiceEvent', result);
  //     return result;
  //   },
  //   queryKey: ['bleServiceEvent'],
  //   throwOnError: true,
  // });

  useEffect(() => {
    if (Platform.OS === 'ios') {
      const removeFirstListener = registerForNotifications((value) => Alert.alert('#1' + JSON.stringify(value)));
      const removeSecondListener = registerForNotifications((value) => Alert.alert('#2' + JSON.stringify(value)));
      return () => {
        removeFirstListener();
        removeSecondListener();
      };
    }
  }, []);

  return (
    <View style={styles.container}>
      <Text>Open up App.js to start working on your app!</Text>
      {isLoading && <Text>isLoading - true</Text>}
      {data && <Text>data - {data as any}</Text>}
      {error && <Text>error - {error.message}</Text>}

      {/*{bleServiceEventIsLoading && <Text>ble isLoading - true</Text>}*/}
      {/*{bleServiceEventData && <Text>ble data - {bleServiceEventData}</Text>}*/}
      {/*{bleServiceEventError && <Text>ble error - {bleServiceEventError.message}</Text>}*/}

      <Button
        title="globalPropertyGetVirtualCardEnabled"
        onPress={() =>
          globalPropertyGetVirtualCardEnabled()
            .then((result) => Alert.alert(JSON.stringify(result)))
            .catch((err) => {
              debugger;
              Alert.alert(err.message);
              throw err;
            })
        }
      />

      <Button
        title="globalPropertySetVirtualCardEnabled"
        onPress={() =>
          globalPropertySetVirtualCardEnabled(Math.random() > 0.5)
            .then((result) => Alert.alert(JSON.stringify(result)))
            .catch((err) => {
              Alert.alert(err.message);
              throw err;
            })
        }
      />

      <Button
        title="libKeyCardGetAPIVersion"
        onPress={() =>
          libKeyCardGetAPIVersion()
            .then((result) => Alert.alert(JSON.stringify(result)))
            .catch((err) => {
              Alert.alert(err.message);
              throw err;
            })
        }
      />

      <StatusBar style="auto" />
    </View>
  );
}

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <Main />
    </QueryClientProvider>
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
