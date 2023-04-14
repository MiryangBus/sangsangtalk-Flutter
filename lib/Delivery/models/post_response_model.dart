import 'package:sangsangtalk/Delivery/models/post_model.dart';

import '../../Auth/models/user_model.dart';

//get /post
class ResponsePost extends PostOption {
  String id;
  String title;
  String userId;
  String nickname;
  Store store;
  bool recruitment;
  bool orderCompleted;
  bool orderConfirmed;
  List<String> users;

  ResponsePost(
      {required this.id,
      required this.title,
      required this.userId,
      required this.nickname,
      required place,
      required minMember,
      required maxMember,
      required orderTime,
      required this.store,
      required this.recruitment,
      required this.orderCompleted,
      required this.orderConfirmed,
      required this.users})
      : super(
          place: place,
          minMember: minMember,
          maxMember: maxMember,
          orderTime: orderTime,
        );

  ResponsePost.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        userId = json['user_id'].toString(),
        nickname = json['nickname'],
        store = Store.fromJson(json['store']),
        recruitment = json['recruitment'],
        orderCompleted = json['order_completed'],
        orderConfirmed = json['order_confirmed'] ?? false,
        users = List<String>.from(json['users'].map((x) => x.toString())),
        super.fromJson(json);
}

// {
// "_id": "6345a45f1c32cd7c4b64d895",
// "name": "맘스터치",
// "min_order": 12000,
// "fee": 3000,
// "menus": [
// {
// "section": "세트메뉴",
// "name": "딥치즈버거",
// "price": 6800
// }
// ]
// }

class StoreMenus extends Store {
  List<MenuSection> menuSection;

  StoreMenus(
      {required String id,
      required String name,
      required int minOrder,
      required int fee,
      required this.menuSection})
      : super(id: id, name: name, minOrder: minOrder, fee: fee);

  StoreMenus.fromJson(Map<String, dynamic> json)
      : menuSection = List<MenuSection>.from(
            json['sections'].map((x) => MenuSection.fromJson(x))),
        super.fromJson(json);
}
