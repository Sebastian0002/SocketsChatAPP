import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:real_time_chat/domain/models/user.dart';
import 'package:real_time_chat/ui/dimensions.dart';
import 'package:real_time_chat/services/provider/sockets_provider.dart';
import 'package:real_time_chat/ui/pages/chats/provider/chat_provider.dart';
import 'package:real_time_chat/ui/pages/home/provider/users_provider.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';
import 'package:real_time_chat/ui/pages/screens.dart';

class ScreenUser extends StatefulWidget {
  const ScreenUser({super.key});

  static const String route = '/screen_users';

  @override
  State<ScreenUser> createState() => _ScreenUserState();
}

class _ScreenUserState extends State<ScreenUser> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{ 
      await context.read<UsersProvider>().getUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.read<AuthProvider>();
    final SocketsProvider socketsProvider = context.watch<SocketsProvider>();
    final UsersProvider usersProvider = context.watch<UsersProvider>();
    
    Future onRefresh() async{
    await usersProvider.getUsers();
    }

    return  Scaffold(
      appBar: AppBar(
        title: Text(authProvider.credentialsUser.nombre.split(" ")[0]),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () async{
            await authProvider.deleteToken();
            socketsProvider.disconnect();
            if(context.mounted) Navigator.pushReplacementNamed(context, ScreenLogin.route);
          },
        ),
        actions: [
          socketsProvider.status == ServerSatus.online
          ? _iconStatus(const Icon(Icons.check_circle_outline, color: Colors.green,),)
          : socketsProvider.status == ServerSatus.offline
          ?_iconStatus(const Icon(Icons.error_outline, color: Colors.red))
          :_iconStatus(LoadingAnimationWidget.discreteCircle(color: Colors.grey, size: 15*responsive.scaleAverage))
        ],
      ),
      body: usersProvider.loading
        ? LoadingAnimationWidget.hexagonDots(color: Colors.blueAccent, size: 30*responsive.scaleAverage)
        :RefreshIndicator.adaptive(
          onRefresh: onRefresh,
          child: _listViewUsers(usersProvider.users)),
    );
  }

  Padding _iconStatus(Widget child) {
    return Padding(
          padding: EdgeInsets.only(right: 15*responsive.scaleWidth),
          child: child
          );
  }

  ListView _listViewUsers(List<User> users) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (_,i)=> const Divider(),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return _userListTile(context,users[index]);
      },
    );
  }

  ListTile _userListTile(BuildContext context, User user) {
    final ChatProvider chatProvider = context.read<ChatProvider>();
    final AuthProvider authProvider = context.read<AuthProvider>();
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.nombre.substring(0,2).toUpperCase()),
      ),
      title: Text(user.nombre),
      subtitle: Text(user.email),
      trailing: user.online
      ?Icon(Icons.circle, color: Colors.green,size: 13*responsive.scaleAverage)
      :Icon(Icons.circle, color: Colors.red,size: 13*responsive.scaleAverage),
      onTap: (){
        chatProvider.setUserDestination(user);
        chatProvider.setFromId(user.uid);
        chatProvider.setToken(authProvider.credentialsUser.token!);
        if(mounted)Navigator.pushNamed(context, ScreenChat.route);
      },
    );
  }
}