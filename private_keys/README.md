## macOS notarizing

To notarize the project, generate an API key at https://appstoreconnect.apple.com/access/api

Put the .p8 file in this folder and copy the Issuer ID from the website.

Enter the Issuer ID and the Key ID in the notarization settings in the export dialog.

### Known issues

If notarization fails with error code 2, ensure the signing key name is correct.

Use `security find-identity -v -p codesigning` to get the valid key names.