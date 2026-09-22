import 'dart:convert';

class Investment {
  final String id;
  final List<String> names;
  final double totalAmount;
  final double ratio;
  final int sortOrder;
  final String? parentId;
  final String? subToolName;
  final double? subToolRatio;
  final DateTime lastUpdated;

  Investment({
    required this.id,
    required this.names,
    required this.totalAmount,
    required this.ratio,
    required this.sortOrder,
    this.parentId,
    this.subToolName,
    this.subToolRatio,
    required this.lastUpdated,
  });

  // 从数据库 Map 转为对象
  factory Investment.fromJson(Map<String, dynamic> json) {
    List<String> names = [];
    final nameData = json['name'];

    if (nameData != null) {
      if (nameData is String) {
        try {
          final decoded = jsonDecode(nameData);
          if (decoded is List) {
            names = decoded.map((e) => e.toString()).toList();
          }
        } catch (e) {
          names = [];
        }
      } else if (nameData is List) {
        names = nameData.map((e) => e.toString()).toList();
      }
    }

    return Investment(
      id: json['id'],
      names: names,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      ratio: (json['ratio'] as num).toDouble(),
      sortOrder: json['sortOrder'] as int,
      parentId: json['parentId'],
      subToolName: json['subToolName'],
      subToolRatio: json['subToolRatio'] != null ? (json['subToolRatio'] as num).toDouble() : null,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  // 转为数据库 Map 存储
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': jsonEncode(names), // Changed key from 'names' to 'name' to match DB column
      'totalAmount': totalAmount,
      'ratio': ratio,
      'sortOrder': sortOrder,
      'parentId': parentId,
      'subToolName': subToolName,
      'subToolRatio': subToolRatio,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}