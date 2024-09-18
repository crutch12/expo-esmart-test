import { StatusBar } from 'expo-status-bar';
import {Button, StyleSheet, Text, View, Alert} from 'react-native';
import { multiply, bleServiceEvent, shutdown, setCardMode, getCardMode, init } from 'react-native-esmart';
import { useQuery, QueryClient, QueryClientProvider } from '@tanstack/react-query';

import SQLite from 'react-native-sqlite-2'

const db = SQLite.openDatabase('test.db', '1.0', '', 1)

console.log(db)

// Create a client
const queryClient = new QueryClient()

const useInit = () => {
  const query = useQuery({
    queryFn: () => init(),
    queryKey: ['init'],
    enabled: false,
  })

  return query;
}

function Main() {
  const a = 2
  const b = 3

  const { data, error, isLoading } = useQuery({
    queryFn: () => multiply(a, b),
    queryKey: ['multiply', a, b],
  })

  const { data: bleServiceEventData, error: bleServiceEventError, isLoading: bleServiceEventIsLoading } = useQuery({
    queryFn: async () => {
      const result = await bleServiceEvent()
      console.log('bleServiceEvent', result)
      return result
    },
    queryKey: ['bleServiceEvent'],
    throwOnError: true,
  })

  // const initQuery = useInit()

  return (
    <View style={styles.container}>
      <Text>Open up App.js to start working on your app!</Text>
      {isLoading && <Text>isLoading - true</Text>}
      {data && <Text>data - {data}</Text>}
      {error && <Text>error - {error.message}</Text>}

      {bleServiceEventIsLoading && <Text>ble isLoading - true</Text>}
      {bleServiceEventData && <Text>ble data - {bleServiceEventData}</Text>}
      {bleServiceEventError && <Text>ble error - {bleServiceEventError.message}</Text>}

      <Button title="Init" onPress={() => init().then(result => Alert.alert(String(result))).catch(err => {
        Alert.alert(err.message)
        throw err;
      })} />
      <Button title="Shutdown" onPress={() => shutdown().then(result => Alert.alert(String(result))).catch(err => {
        Alert.alert(err.message)
        throw err;
      })} />
      <StatusBar style="auto" />
    </View>
  );
}

export default function App() {
  return <QueryClientProvider client={queryClient}>
      <Main />
  </QueryClientProvider>
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
