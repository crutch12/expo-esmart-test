import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { multiply } from 'react-native-esmart';
import { useQuery, QueryClient, QueryClientProvider } from '@tanstack/react-query';

import SQLite from 'react-native-sqlite-2'

const db = SQLite.openDatabase('test.db', '1.0', '', 1)

console.log(db)

// Create a client
const queryClient = new QueryClient()

function Main() {
  const { data, error, isLoading } = useQuery({
    queryFn: () => multiply(2, 3),
    queryKey: [],
  })

  return (
    <View style={styles.container}>
      <Text>Open up App.js to start working on your app!</Text>
      {isLoading && <Text>isLoading - true</Text>}
      {data && <Text>data - {data}</Text>}
      {error && <Text>error - {error.message}</Text>}
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
