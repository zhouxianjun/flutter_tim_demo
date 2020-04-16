import 'package:tim_demo/store/app.dart';
import 'package:event_bus/event_bus.dart';
import 'package:provider/provider.dart';

final AppStore appStore = AppStore();
List<Provider> _providers;
get providers {
    if (_providers == null) {
        _providers = [
            Provider<AppStore>(create: (_) => appStore),
            Provider<EventBus>(create: (_) => EventBus())
        ];
    }
    return _providers;
}