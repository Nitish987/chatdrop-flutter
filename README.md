# Chatdrop

Social media application developed by Nitish Kumar.

### Features

- Authentication

- OAuth (with google sign in)

- Profile 

- Post

- Stories

- Reels

- Friends

- Fan Following

- Chats (with single layer encryption)

- Secret Chats (with end-to-end encryption using signal-protocol)

- Olivia Ai (powered with chatgpt)

- Search

- Notifications

- Privacy and Blocking System

- Security (using AES-256 bit encryption)

### Getting Started

- Create local.env file with the following code in it.

```
API_URL='SERVER_API_URL'
API_KEY='SERVER_API_KEY'
ACCOUNT_CREATION_KEY='SERVER_ACCOUNT_CREATION_KEY'
WEBSOCKET_URL='WEBSOCKET_URL'
```

- Also go through all the files located in lib/settings directory

- This app requires firebase connectivity also. Connect this project to firebase and move firebase_options.dart file to lib/settings/firebase directory

### Related Repositories

- [Chatdrop Web App](https://github.com/Nitish987/chatdrop-react)

- [Chatdrop Server](https://github.com/Nitish987/chatdrop-django)