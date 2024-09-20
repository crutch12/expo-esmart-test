# Credentials (com.capitalgroup.living)

- Credentials: /credentials.json

```json
{
  "ios": {
    "distributionCertificate": {
      "path": "credentials/ios/dist-cert.p12",
      "password": "__CERTIFICATE_PASSWORD__"
    },
    "provisioningProfilePath": "credentials/ios/profile.mobileprovision"
  }
}
```

# iOS

- Profile: /credentials/ios/profile.mobileprovision
- Certificate: /credentials/ios/dist-cert.p12

# Android

@TODO

# GitHub Actions

- credentials.json -> base64 -> secrets.EXPO_CREDENTIALS_BASE64
- credentials/ios/profile.mobileprovision -> base64 -> secrets.EXPO_IOS_PROFILE_BASE64
- credentials/ios/dist-cert.p12 -> base64 -> secrets.EXPO_IOS_CERT_BASE64
