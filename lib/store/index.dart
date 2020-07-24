import 'package:tim_demo/store/app.dart';
import 'package:event_bus/event_bus.dart';
import 'package:provider/provider.dart';
import 'package:tim_demo/store/im.dart';

final AppStore appStore = AppStore();
final IMStore imStore = IMStore();
List<Provider> _providers;
get providers {
    if (_providers == null) {
        _providers = [
            Provider<AppStore>(create: (_) => appStore),
            Provider<IMStore>(create: (_) => imStore),
            Provider<EventBus>(create: (_) => EventBus())
        ];
    }
    return _providers;
}