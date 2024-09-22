# Add in current dir:

- libEsmartVirtualCard.a

# Or decrypt using

```shell
$ gpg --yes --batch --decrypt --passphrase "$ENCRYPTION_PASSPHRASE" -o ./modules/esmart/ios/libEsmartVirtualCard.a ./modules/esmart/ios/libEsmartVirtualCard.a.gpg
```