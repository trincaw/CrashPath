import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:crashpath/interface/bar_life_component.dart';

class KnightInterface extends GameInterface {
  @override
  Future<void> onLoad() async {
    add(BarLifeComponent());
    return super.onLoad();
  }
}
