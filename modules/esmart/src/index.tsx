import { NativeModules, Platform } from 'react-native';
import { createGlobalListener, type Destructor } from './listeners';

const LINKING_ERROR =
  `The package 'react-native-esmart' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export interface EsmartEvent {
  EVT:
    | 'ADVERTISEMENT_STATE'
    | 'GROUP_DISABLED'
    | 'CAN_MANUAL_SEND_USERID'
    | 'GROUP_EXPIRED'
    | 'IMPORT'
    | 'GROUP_SUSPENDED'
    | 'READER_EVENT'
    | 'USERID_FOR_GROUP_REQUIRED'
    | 'RSSI_CHANGED'
    | 'ADVERTISEMENT_STARTED'
    | 'HIDE_NOTIFICATION'
    | 'SHOW_NOTIFICATION'
    | 'REFRESH_READERS_LIST'
    | 'POWER_RESET'
    | 'POWER_OFF'
    | 'POWER_ON';
  READER?: string;
  USERID_SENT?: string;
  ERROR?: string;
  STATE?: 'GROUP_DETERMINED' | 'IDENTIFIER_DETERMINED' | 'START' | 'FINISH' | 'OFF' | 'ON' | 'FAILED';
  RESULT?: string;
  GROUP?: string;
  READER_IDENTIFIER?: string;
  TYPE?: string;
}

const Esmart = NativeModules.Esmart
  ? NativeModules.Esmart
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      },
    );

export function multiply(a: number, b: number): Promise<number> {
  return Esmart.multiply(a, b);
}

export function bleServiceEvent(): Promise<any> {
  return Esmart.bleServiceEvent();
}

const addRegisterForNotifications = createGlobalListener<[EsmartEvent]>(
  // Esmart.registerForNotifications should be called only once, so wrap it with createGlobalListener
  (globalListener) => Esmart.registerForNotifications(globalListener),
);

export function registerForNotifications(listener: (result: EsmartEvent) => void): Destructor {
  return addRegisterForNotifications(listener);
}

export function globalPropertyGetVirtualCardEnabled(): Promise<boolean> {
  return Esmart.globalPropertyGetVirtualCardEnabled();
}

export function globalPropertySetVirtualCardEnabled(value: boolean): Promise<boolean> {
  return Esmart.globalPropertySetVirtualCardEnabled(value);
}

export function globalPropertyGetPersistedUserIdStore(): Promise<boolean> {
  return Esmart.globalPropertyGetPersistedUserIdStore();
}

export function globalPropertySetPersistedUserIdStore(value: boolean): Promise<boolean> {
  return Esmart.globalPropertySetPersistedUserIdStore(value);
}

export function globalPropertyGetUseExternalUserIdGenerator(): Promise<boolean> {
  return Esmart.globalPropertyGetUseExternalUserIdGenerator();
}

export function globalPropertySetUseExternalUserIdGenerator(value: boolean): Promise<boolean> {
  return Esmart.globalPropertySetUseExternalUserIdGenerator(value);
}

export function globalPropertyGetOldDeviceOverride(): Promise<boolean> {
  return Esmart.globalPropertyGetOldDeviceOverride();
}

export function globalPropertySetOldDeviceOverride(value: boolean): Promise<boolean> {
  return Esmart.globalPropertySetOldDeviceOverride(value);
}

export function globalPropertyGetTapAreaComfortSelector(): Promise<boolean> {
  return Esmart.globalPropertyGetTapAreaComfortSelector();
}

export function globalPropertySetTapAreaComfortSelector(value: boolean): Promise<boolean> {
  return Esmart.globalPropertySetTapAreaComfortSelector(value);
}

export function globalPropertyGetOnlyKnownGroupsAllowed(): Promise<boolean> {
  return Esmart.globalPropertyGetOnlyKnownGroupsAllowed();
}

export function globalPropertySetOnlyKnownGroupsAllowed(value: boolean): Promise<boolean> {
  return Esmart.globalPropertySetOnlyKnownGroupsAllowed(value);
}

export function libKeyCardGetAPIVersion(): Promise<string> {
  return Esmart.libKeyCardGetAPIVersion();
}

export function loggerDumpLogs(): Promise<true> {
  return Esmart.loggerDumpLogs();
}

export function loggerPurgeLogs(): Promise<true> {
  return Esmart.loggerPurgeLogs();
}

export function loggerGetCountLogs(): Promise<number> {
  return Esmart.loggerGetCountLogs();
}

export function loggerSetRealTimeLog(value: boolean): Promise<boolean> {
  return Esmart.loggerSetRealTimeLog(value);
}

export function loggerPauseLogs(): Promise<true> {
  return Esmart.loggerPauseLogs();
}

export function loggerGetLogsPaused(): Promise<boolean> {
  return Esmart.loggerGetLogsPaused();
}

export function groupGetInfo(groupId: string): Promise<Record<string, string | boolean | number>> {
  return Esmart.groupGetInfo(groupId);
}

export function groupVerifyDone(groupId: string): Promise<number> {
  return Esmart.groupVerifyDone(groupId);
}

export function readerProfileGetInfo(readerId: string): Promise<Record<string, string | boolean | number>> {
  return Esmart.readerProfileGetInfo(readerId);
}

export function readerProfileIsIdentifierDetermined(readerId: string): Promise<boolean> {
  return Esmart.readerProfileIsIdentifierDetermined(readerId);
}

export function importerSetAESKey(base64Key: string): Promise<true> {
  return Esmart.importerSetAESKey(base64Key);
}

export function importerGenerateAndSetAESKey(): Promise<string> {
  return Esmart.importerGenerateAndSetAESKey();
}

export function importerImportDataFromFiles(files: string[]): Promise<true> {
  return Esmart.importerImportDataFromFiles(files);
}

export function importerImportDataFromFile(file: string): Promise<true> {
  return Esmart.importerImportDataFromFile(file);
}
