import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:real_time_chat/services/provider/sockets_provider.dart';
import 'package:real_time_chat/ui/pages/chats/provider/chat_provider.dart';
import 'package:real_time_chat/ui/pages/home/provider/users_provider.dart';
import 'package:real_time_chat/ui/pages/login-SignUp/provider/auth_provider.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => SocketsProvider()),
  ChangeNotifierProvider(create: (_) => UsersProvider()),
  ChangeNotifierProvider(create: (_) => ChatProvider()),
];
