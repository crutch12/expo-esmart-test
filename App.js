import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { multiply, bleServiceEvent } from 'react-native-esmart';
import { useQuery, QueryClient, QueryClientProvider } from '@tanstack/react-query';

import SQLite from 'react-native-sqlite-2'

const db = SQLite.openDatabase('test.db', '1.0', '', 1)

console.log(db)

// Create a client
const queryClient = new QueryClient()

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

  return (
    <View style={styles.container}>
      <Text>Open up App.js to start working on your app!</Text>
      {isLoading && <Text>isLoading - true</Text>}
      {data && <Text>data - {data}</Text>}
      {error && <Text>error - {error.message}</Text>}

      {bleServiceEventIsLoading && <Text>ble isLoading - true</Text>}
      {bleServiceEventData && <Text>ble data - {bleServiceEventData}</Text>}
      {bleServiceEventError && <Text>ble error - {bleServiceEventError.message}</Text>}

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
