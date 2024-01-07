// import 'package:dm_assistant/status.dart';
// import 'package:hive/hive.dart';

// part 'hive_character.g.dart'; 

// @HiveType(typeId: 0)
// class HiveCharacter extends HiveObject {
//   @HiveField(0)
//   late int initiativeBonus;

//   @HiveField(1)
//   late int? initiativeScore;

//   @HiveField(2)
//   late String name;

//   @HiveField(3)
//   late List<Status> status = [];

//   @HiveField(4)
//   late bool active = true;

//   @HiveField(5)
//   late bool enabled = true;

//   @HiveField(6)
//   HiveList campaign;

//   HiveCharacter({
//     required this.initiativeBonus,
//     this.initiativeScore,
//     required this.name,
//     List<Status>? status,
//     this.active = true,
//     this.enabled = true,
//     required this.campaign,
//   }) : status = status ?? [];
// }
