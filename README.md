# SocketsChatAPP : Flutter application focused on socket services 💥

Hey there, this is a mobile application built with Flutter and Node.js. Basically, the app's functionality is similar to instant messengers like WhatsApp or Telegram.

This application was built using good programming practices such as Clean Architecture, SOLID principles, and design patterns like Factory. It also implements provider state management and uses Shared Preferences as a local database to store JWTs for authentication and user states.

# Features:

There are some features that this project has:

1. Functional authentication for login and signup using credentials or Google, as well as the use of tokens with a Node.js backend 👨🏻‍💻.
2. Construction of messaging and channels using socket.io in Node.js and achieving proper integration with Flutter for message flow between users 💬.
3. Control and management of requests using JWT, also evaluating whether it is still active 🔑.

# Let's build the project

First clone the repository `git clone git@github.com:Sebastian0002/SocketsChatAPP.git`
Then go to the directory, open the terminal here, and `cd NodeChatAppServer` 

* execute `npm install` 
* download the .env file for Node project [.env](https://res.cloudinary.com/dhopfnum1/raw/upload/v1729311391/zo3etvpzmkqfggpdqtye.env)
* rename it as .env and put this in the root of NodeChatAppServer
* and execute `nodemon start:dev`

Those steps will help you get the backend server up and running.

Now we need to configure one more thing in the flutter project go to `lib/constants/environments.dart` and set your Ip address here.

Now just run the app and give it a try! 😁
