import 'package:flutter/material.dart';
import '../../../core/models/investment.dart';
import '../../../core/repositories/investment_repository.dart';
import '../../../core/repositories/investment_repository_impl.dart';
import 'package:uuid/uuid.dart';

class InvestmentProvider extends ChangeNotifier {
  final IInvestmentRepository _repository;
  List<Investment> _allInvestments = [];

  InvestmentProvider(this._repository) {
    _loadInitialData();
  }

  List<Investment> get mainRows => _allInvestments.where((e) => e.parentId == null).toList();
  List<Investment> get allInvestments => _allInvestments;

  Future<void> _loadInitialData() async {
    _allInvestments = await _repository.getAllInvestments();
    _sortInvestments();
    notifyListeners();
  }

  void _sortInvestments() {
    _allInvestments.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  // 保存所有内存中的更改到数据库
  Future<void> saveAll() async {
    for (var item in _allInvestments) {
      await _repository.saveInvestment(item);
    }
    notifyListeners();
  }

  // 添加主行（仅更新内存）
  Future<void> addRow(String toolName, double initialRatio) async {
    final newRow = Investment(
      id: const Uuid().v4(),
      name: toolName,
      totalAmount: 0,
      ratio: initialRatio,
      sortOrder: _allInvestments.length + 1,
      parentId: null,
      lastUpdated: DateTime.now(),
    );

    _allInvestments.add(newRow);
    _sortInvestments();
    notifyListeners();
  }

  // 删除主行（更新内存并重新计算排序）
  Future<void> removeRow(String id) async {
    _allInvestments.removeWhere((e) => e.id == id || e.parentId == id);

    // 重新分配主行的排序序号，确保顺序不跳变
    final mainRows = _allInvestments.where((e) => e.parentId == null).toList();
    for (int i = 0; i < mainRows.length; i++) {
      final item = mainRows[i];
      final updated = Investment(
        id: item.id,
        name: item.name,
        totalAmount: item.totalAmount,
        ratio: item.ratio,
        sortOrder: i + 1,
        parentId: item.parentId,
        subToolName: item.subToolName,
        subToolRatio: item.subToolRatio,
        lastUpdated: DateTime.now(),
      );
      final index = _allInvestments.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        _allInvestments[index] = updated;
      }
    }

    _sortInvestments();
    notifyListeners();
  }

  // 添加子工具（仅更新内存）
  Future<void> addSubTool(String parentId, String subName, double subRatio) async {
    final newSub = Investment(
      id: const Uuid().v4(),
      name: subName,
      totalAmount: 0,
      ratio: subRatio,
      sortOrder: 999,
      parentId: parentId,
      lastUpdated: DateTime.now(),
    );

    _allInvestments.add(newSub);
    _sortInvestments();
    notifyListeners();
  }

  // 删除子工具（仅更新内存）
  Future<void> removeSubTool(String id) async {
    _allInvestments.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // 更新比例（仅更新内存）
  Future<void> updateRatio(String id, double newRatio) async {
    final index = _allInvestments.indexWhere((e) => e.id == id);
    if (index != -1) {
      final item = _allInvestments[index];
      final updated = Investment(
        id: item.id,
        name: item.name,
        totalAmount: item.totalAmount,
        ratio: newRatio,
        sortOrder: item.sortOrder,
        parentId: item.parentId,
        subToolName: item.subToolName,
        subToolRatio: item.subToolRatio,
        lastUpdated: DateTime.now(),
      );

      _allInvestments[index] = updated;
      notifyListeners();
    }
  }

  // 更新名称（仅更新内存）
  Future<void> updateName(String id, String newName) async {
    final index = _allInvestments.indexWhere((e) => e.id == id);
    if (index != -1) {
      final item = _allInvestments[index];
      final updated = Investment(
        id: item.id,
        name: newName,
        totalAmount: item.totalAmount,
        ratio: item.ratio,
        sortOrder: item.sortOrder,
        parentId: item.parentId,
        subToolName: item.subToolName,
        subToolRatio: item.subToolRatio,
        lastUpdated: DateTime.now(),
      );

      _allInvestments[index] = updated;
      notifyListeners();
    }
  }

  // 将总投资金额保存到第一个主行中
  Future<void> updateGlobalTotal(double amount) async {
    final mainRows = _allInvestments.where((e) => e.parentId == null).toList();
    if (mainRows.isNotEmpty) {
      final firstRow = mainRows.first;
      final updated = Investment(
        id: firstRow.id,
        name: firstRow.name,
        totalAmount: amount,
        ratio: firstRow.ratio,
        sortOrder: firstRow.sortOrder,
        parentId: firstRow.parentId,
        subToolName: firstRow.subToolName,
        subToolRatio: firstRow.subToolRatio,
        lastUpdated: DateTime.now(),
      );

      final index = _allInvestments.indexWhere((e) => e.id == firstRow.id);
      if (index != -1) {
        _allInvestments[index] = updated;
        notifyListeners();
      }
    }
  }
}