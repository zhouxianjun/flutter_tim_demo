import 'package:flutter/cupertino.dart';
import 'package:tim_demo/dto/friend_index_dto.dart';

class UserProfileItemDTO {
  final String text;
  final Widget value;
  final VoidCallback onClick;
  UserProfileItemDTO({@required this.text, this.value, this.onClick});
}
