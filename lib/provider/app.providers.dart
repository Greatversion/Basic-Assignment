import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'notifiers/authentication.notifier.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create:(_)=> AuthenticationNotifier())
  ];
}
