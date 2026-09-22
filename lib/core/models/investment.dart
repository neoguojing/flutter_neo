class Investment {
  final String id;
  final String name;
  final double totalAmount;
  final double ratio;
  final int sortOrder;
  final String? parentId;
  final String? subToolName;
  final double? subToolRatio;
  final DateTime lastUpdated;

  Investment({
    required this.id,
    required this.name,
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
    return Investment(
      id: json['id'],
      name: json['name'],
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
      'name': name,
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
