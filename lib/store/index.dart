import 'package:tim_demo/store/app.dart';
import 'package:event_bus/event_bus.dart';
import 'package:provider/provider.dart';
import 'package:tim_demo/store/im.dart';
import 'package:tim_demo/store/mine.dart';

final IMStore imStore = IMStore();
final MineStore mineStore = MineStore();
final AppStore appStore = AppStore(mineStore);
List<Provider> _providers;
get providers {
    if (_providers == null) {
        _providers = [
            Provider<AppStore>(create: (_) => appStore),
            Provider<IMStore>(create: (_) => imStore),
            Provider<MineStore>(create: (_) => mineStore),
            Provider<EventBus>(create: (_) => EventBus())
        ];
    }
    return _providers;
}