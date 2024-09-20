//
//  AlphaOpen.h
//  AlphaOpen
//
//  Created by Денис Либит on 04.03.2019.
//

#import "AppDelegate.h"

@interface AppDelegate (Launch)

@end

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNEsmartSpec.h"

@interface Esmart : NSObject <NativeEsmartSpec>
#else
#import <React/RCTBridgeModule.h>

@interface Esmart : NSObject <RCTBridgeModule>
#endif


@end



// #import <Cordova/CDV.h>
// #import "Esmart.h"
//
//
//
// @interface AlphaOpen : CDVPlugin

// #pragma mark - Настройки
//
// // общий выключатель библиотеки
// - (void)globalPropertyGetVirtualCardEnabled:(CDVInvokedUrlCommand *)command;
// - (void)globalPropertySetVirtualCardEnabled:(CDVInvokedUrlCommand *)command;
//
// // сохранять ли UserId в keychain устройства
// - (void)globalPropertyGetPersistedUserIdStore:(CDVInvokedUrlCommand *)command;
// - (void)globalPropertySetPersistedUserIdStore:(CDVInvokedUrlCommand *)command;
//
// // использовать внешний генератор значения UserId
// - (void)globalPropertyGetUseExternalUserIdGenerator:(CDVInvokedUrlCommand *)command;
// - (void)globalPropertySetUseExternalUserIdGenerator:(CDVInvokedUrlCommand *)command;
//
// // позволять ли работать библиотеке на старых устройствах (iPhone 4S, iPod Touch 5)
// - (void)globalPropertyGetOldDeviceOverride:(CDVInvokedUrlCommand *)command;
// - (void)globalPropertySetOldDeviceOverride:(CDVInvokedUrlCommand *)command;
//
// // режим работы библиотеки, при котором отключается вся функциональность протокола «считыватель-телефон» за исключением получения телефоном значений уровня сигнала.
// // используется в мастере пользовательской настройки расстояний зон.
// - (void)globalPropertyGetTapAreaComfortSelector:(CDVInvokedUrlCommand *)command;
// - (void)globalPropertySetTapAreaComfortSelector:(CDVInvokedUrlCommand *)command;
//
// // игнорировать обработку обмена со считывателями из неопознанных групп (желательно устанавливать в YES)
// - (void)globalPropertyGetOnlyKnownGroupsAllowed:(CDVInvokedUrlCommand *)command;
// - (void)globalPropertySetOnlyKnownGroupsAllowed:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - libKeyCard
//
// // возвращает текущей номер версии библиотеки
// - (void)libKeyCardGetAPIVersion:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - ReaderController
//
// // загрузить (обновить у объекта reader) параметры из хранилища.
// - (void)readerControllerLoadDBConfigForReader:(CDVInvokedUrlCommand *)command;
//
// // сохранить параметры считывателя в хранилище.
// - (void)readerControllerUpdateConfigForReader:(CDVInvokedUrlCommand *)command;
//
// // устанавливает телефон в состояние «отправить userId».
// - (void)readerControllerSendUserIdToReader:(CDVInvokedUrlCommand *)command;
//
// // предписывает считывателю перечитать конфигурацию с телефона.
// - (void)readerControllerRequestReReadConfig:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - ReadersManager
//
// // возвращает список считывателей
// - (void)readersManagerGetReadersPool:(CDVInvokedUrlCommand *)command;
//
// // удаляет все считыватели по заданной группе
// - (void)readersManagerDeleteReadersByGroupID:(CDVInvokedUrlCommand *)command;
//
// // удалить считыватель по заданному идентификатору
// - (void)readersManagerDeleteReader:(CDVInvokedUrlCommand *)command;
//
// // возвращает список считывателей для заданной группы
// - (void)readersManagerGetReadersListForGroup:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - GroupsManager
//
// // возвращает список групп
// - (void)groupsManagerGetGroupsList:(CDVInvokedUrlCommand *)command;
//
// // обновляет некоторые параметры группы
// - (void)groupsManagerUpdateGroup:(CDVInvokedUrlCommand *)command;
//
// // удалить информацию о заданной группе
// - (void)groupsManagerDeleteGroup:(CDVInvokedUrlCommand *)command;
//
// // устанавливает скорость выполнения проверок на истечение срока выдачи доступа
// - (void)groupsManagerSetExpireCheckStrategyFast:(CDVInvokedUrlCommand *)command;
//
// // если YES, то у группы истёк срок выдачи доступа
// - (void)groupsManagerGetIsExpired:(CDVInvokedUrlCommand *)command;
//
// // помечает группу как "приостановленную"
// - (void)groupsManagerSetGroupEnabled:(CDVInvokedUrlCommand *)command;
//
// // возвращает флаг, что в управлении библиотеки есть хотя бы одна активная в текущий момент группа
// - (void)groupsManagerIsActiveGroupExist:(CDVInvokedUrlCommand *)command;
//
// // возвращает флаг, что в управлении библиотеки есть хотя бы одна приостановленная (enabled:NO) в текущий момент группа
// - (void)groupsManagerIsSuspendedGroupExist:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - BLEAdvertiser
//
// // возвращает состояние вещания сервиса
// - (void)bleAdvertiserIsAdvertising:(CDVInvokedUrlCommand *)command;
//
// // предписывает начать вещание
// - (void)bleAdvertiserStartAdvertising:(CDVInvokedUrlCommand *)command;
//
// // предписывает остановить вещание
// - (void)bleAdvertiserStopAdvertising:(CDVInvokedUrlCommand *)command;
//
// // указывает библиотеке допустимость отправки userId в считыватель
// - (void)bleAdvertiserEnableSendUserId:(CDVInvokedUrlCommand *)command;
//
// // указывает библиотеке недопустимость отправки userId в считыватель
// - (void)bleAdvertiserDisableSendUserId:(CDVInvokedUrlCommand *)command;
//
// // возвращает, возможна ли работа библиотеки как фонового процесса
// - (void)bleAdvertiserGetBackgroundProcessingEnabled:(CDVInvokedUrlCommand *)command;
//
// // указывает библиотеке на возможность работать как фоновый процесс
// - (void)bleAdvertiserSetBackgroundProcessingEnabled:(CDVInvokedUrlCommand *)command;
//
// // позволяет отключить механизмы автоматического запуска/останова вещания при изменениях внешних условий
// - (void)bleAdvertiserRelauchControlledExternally:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - BeaconMonitor
//
// // подготовка к мониторингу регионов
// - (void)beaconMonitorPrepare:(CDVInvokedUrlCommand *)command;
//
// // включить мониторинг регионов
// - (void)beaconMonitorStart:(CDVInvokedUrlCommand *)command;
//
// // отключить мониторинг регионов
// - (void)beaconMonitorStop:(CDVInvokedUrlCommand *)command;
//
// // начать отслеживание входа в бикон-регион
// - (void)beaconMonitorAddBeaconRegionMonitoring:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - Importer
//
// // установка ключа шифрования
// - (void)importerSetAESKey:(CDVInvokedUrlCommand *)command;
//
// // установка ключа шифрования
// - (void)importerGenerateAndSetAESKey:(CDVInvokedUrlCommand *)command;
//
// // запуск процедуры импорта нескольких файлов
// - (void)importerImportDataFromFiles:(CDVInvokedUrlCommand *)command;
//
// // запуск процедуры импорта одного файла
// - (void)importerImportDataFromFile:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - ReaderProfile
//
// // получить параметры указанного ReaderProfile
// - (void)readerProfileGetInfo:(CDVInvokedUrlCommand *)command;
//
// // индикатор определения идентификатора у считывателя
// - (void)readerProfileIsIdentifierDetermined:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - Group
//
// // получить параметры указанной группы
// - (void)groupGetInfo:(CDVInvokedUrlCommand *)command;
//
// // вспомогательный метод, возвращает дату/время импорта окончательных настроек группы в библиотеку
// -(void) groupVerifyDone:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - DataFormatter
//
// /// Переводит ASCII-строку с шестнадцатеричными цифрами в последовательность байтового представления
// -(void) dataFromHexString:(CDVInvokedUrlCommand *)command;
//
// /// преобразует байты данных в ASCII-строку.
// -(void) bytesToHexString:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - Logger
//
// /// Cброс накопленных логов в отладочную консоль
// -(void) loggerDumpLogs:(CDVInvokedUrlCommand *)command;
//
// /// Принудительное удаление логов
// -(void) loggerPurgeLogs:(CDVInvokedUrlCommand *)command;
//
// /// Возвращает число лог-записей (одна запись - одно событие)
// -(void) loggerGetCountLogs:(CDVInvokedUrlCommand *)command;
//
// /// флаг вывода логируемых событий в отладочную консоль в момент возникновения события.
// -(void) loggerSetRealTimeLog:(CDVInvokedUrlCommand *)command;
//
// /// включить/выключить логирование
// -(void) loggerPauseLogs:(CDVInvokedUrlCommand *)command;
//
// /// Текущее состояние ведения логов.
// -(void) loggerGetLogsPaused:(CDVInvokedUrlCommand *)command;
//
// #pragma mark - Уведомления
//
// // зарегистрироваться для получения уведомлений
// - (void)registerForNotifications:(CDVInvokedUrlCommand *)command;

// @end
