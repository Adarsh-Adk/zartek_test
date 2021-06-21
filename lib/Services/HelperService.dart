import 'package:hive/hive.dart';

class HelperService {
  closeAllBoxes() async {
    Box cartBox = Hive.box("cart");
    Box cartTotalBox = Hive.box("cartTotal");
    Box userBox = Hive.box("user");
    cartBox.close();
    cartTotalBox.close();
    userBox.close();
  }

  openAllBoxes() async {
    print("open all boxes called");
    bool a = Hive.isBoxOpen("cart");
    bool b = Hive.isBoxOpen("cartTotal");
    bool c = Hive.isBoxOpen("user");
    if (!a) {
      await Hive.openBox("cart");
      print("cart open");
    }
    if (!b) {
      await Hive.openBox("cartTotal");
      print("cartTotal open");
    }
    if (!c) {
      await Hive.openBox("user");
      print("user open");
    }
  }

  clearAllBoxes() async {
    Box cartBox = Hive.box("cart");
    Box cartTotalBox = Hive.box("cartTotal");
    Box userBox = Hive.box("user");
    await cartBox
        .clear()
        .then((value) async => await cartTotalBox.clear())
        .whenComplete(() async => await userBox.clear())
        .then((value) => print("boxes cleared"));
  }

  deleteAllBoxes() async {
    Box cartBox = Hive.box("cart");
    Box cartTotalBox = Hive.box("cartTotal");
    Box userBox = Hive.box("user");
    await cartBox.deleteFromDisk();
    await cartTotalBox.deleteFromDisk();
    await userBox.deleteFromDisk();
  }
}
