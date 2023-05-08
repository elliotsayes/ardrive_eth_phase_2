# ardrive_eth_phase_2

A Proof of Concept in Flutter for deriving ArFS drive keys from Metamask Ethereum Wallets, on Android & Web

## Using this demo

### Android

#### Setup
1. Install Metamask app & generate or import a key

#### Run
1. Click the 'WalletConnect' button, then connect
2. Your wallet application (e.g. Metamask) should open, click Connect & the flutter app should auto-proceed to the 'Drive Key' screen
3. Click the 'Derive Drive Key' button
4. Switch back to your wallet application, and click sign on the message
5. Observe  

### Web

#### Setup
1. Enable extensions on Flutter dev chrome by following these instructions: https://stackoverflow.com/a/71747975
2. Run `flutter run -d chrome` to launch Flutter dev chrome.
3. Install the Metamask Chrome extension in that same chrome window: https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn
4. Generate or import your key into metamask
5. Reload the flutter application

#### Run
1. If using WalletConnect, follow the same instructions for mobile, except instead of clicking Connect in the modal, scan the QR code from your mobile wallet application (top right button in Metamask mobile app)
2. If using the Metamask button, follow the on screen instructions from the extension pop-up.
