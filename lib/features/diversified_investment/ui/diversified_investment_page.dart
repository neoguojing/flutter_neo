import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/investment_provider.dart';

class DiversifiedInvestmentPage extends StatefulWidget {
  const DiversifiedInvestmentPage({super.key});

  @override
  State<DiversifiedInvestmentPage> createState() => _DiversifiedInvestmentPageState();
}

class _DiversifiedInvestmentPageState extends State<DiversifiedInvestmentPage> {
  late TextEditingController _totalAmountController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<InvestmentProvider>(context, listen: false);
    _totalAmountController = TextEditingController(
      text: provider.globalTotalAmount == 0 ? '' : provider.globalTotalAmount.toString(),
    );
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InvestmentProvider>(context);
    final totalRatio = provider.totalMainRatio;
    final totalAmount = provider.globalTotalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('分散投资'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 总投资金额输入框
            const Text(
              '总投资金额',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 320,
              child: TextField(
                controller: _totalAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                decoration: const InputDecoration(
                  prefixText: '￥ ',
                  hintText: '输入总金额',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (text) {
                  final parsed = double.tryParse(text) ?? 0.0;
                  provider.updateGlobalTotal(parsed);
                },
              ),
            ),
            const SizedBox(height: 16),

            // 比例汇总提示
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '投资工具清单',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '总比例: ${totalRatio.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: totalRatio > 100 ? Colors.red : Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. 投资工具卡片列表
            ...provider.mainRows.map((row) {
              return _InvestmentCard(
                key: ValueKey(row.id),
                row: row,
                totalAmount: totalAmount,
              );
            }),

            const SizedBox(height: 16),

            // 添加新行按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => provider.addRow('黄金', 0),
                icon: const Icon(Icons.add),
                label: const Text('添加新行'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 保存按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await provider.saveAll();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('保存成功')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('保存', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ---------------------- 主投资类别卡片组件 ----------------------
class _InvestmentCard extends StatefulWidget {
  final dynamic row;
  final double totalAmount;

  const _InvestmentCard({
    super.key,
    required this.row,
    required this.totalAmount,
  });

  @override
  State<_InvestmentCard> createState() => _InvestmentCardState();
}

class _InvestmentCardState extends State<_InvestmentCard> {
  static const List<String> _tools = ['黄金', '国债', '货币基金', '股票'];
  late TextEditingController _ratioController;

  @override
  void initState() {
    super.initState();
    _ratioController = TextEditingController(text: widget.row.ratio.toString());
  }

  @override
  void didUpdateWidget(covariant _InvestmentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部更新且未聚焦输入时同步数值，防止输入时被打断
    if (widget.row.ratio != oldWidget.row.ratio &&
        double.tryParse(_ratioController.text) != widget.row.ratio) {
      _ratioController.text = widget.row.ratio.toString();
    }
  }

  @override
  void dispose() {
    _ratioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InvestmentProvider>(context);
    final rowAmount = widget.totalAmount * (widget.row.ratio / 100);
    final double subTotalRatio = provider.getSubToolTotal(widget.row.id);
    final subInvestments = provider.allInvestments.where((sub) => sub.parentId == widget.row.id).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 第一行：工具选择和比例
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButton<String>(
                    value: widget.row.names.isNotEmpty ? widget.row.names.first : null,
                    isExpanded: true,
                    items: _tools.map((tool) {
                      final isUsedByOther = provider.usedTools.contains(tool) &&
                          !widget.row.names.contains(tool);
                      return DropdownMenuItem<String>(
                        value: tool,
                        enabled: !isUsedByOther,
                        child: Text(
                          tool,
                          style: TextStyle(
                            color: isUsedByOther ? Colors.grey : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        provider.updateName(widget.row.id, [val]);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _ratioController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: '0%',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    onChanged: (val) {
                      provider.updateRatio(widget.row.id, double.tryParse(val) ?? 0.0);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 第二部分：子工具区域
            if (subInvestments.isNotEmpty) ...[
              const Text(
                '子工具细分',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    ...subInvestments.map((sub) {
                      return _SubInvestmentItem(
                        key: ValueKey(sub.id),
                        sub: sub,
                        parentAmount: rowAmount,
                        onDelete: () => provider.removeSubTool(sub.id),
                        onNameChanged: (val) => provider.updateName(sub.id, [val]),
                        onRatioChanged: (val) => provider.updateRatio(sub.id, val),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => provider.addSubTool(widget.row.id, '新子类别', 0),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('添加子类', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  '子类总比例: ${subTotalRatio.toStringAsFixed(2)}% ${subTotalRatio > 100 ? '(超出 100%)' : ''}',
                  style: TextStyle(
                    fontSize: 11,
                    color: subTotalRatio > 100 ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ] else ...[
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => provider.addSubTool(widget.row.id, '新子类别', 0),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('添加子类细分', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
            const SizedBox(height: 12),

            // 第三行：金额和删除
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '预计投入: ￥${rowAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => provider.removeRow(widget.row.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- 子工具单行组件 ----------------------
class _SubInvestmentItem extends StatefulWidget {
  final dynamic sub;
  final double parentAmount;
  final VoidCallback onDelete;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<double> onRatioChanged;

  const _SubInvestmentItem({
    super.key,
    required this.sub,
    required this.parentAmount,
    required this.onDelete,
    required this.onNameChanged,
    required this.onRatioChanged,
  });

  @override
  State<_SubInvestmentItem> createState() => _SubInvestmentItemState();
}

class _SubInvestmentItemState extends State<_SubInvestmentItem> {
  late TextEditingController _nameController;
  late TextEditingController _ratioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.sub.names.isNotEmpty ? widget.sub.names.first : '',
    );
    _ratioController = TextEditingController(text: widget.sub.ratio.toString());
  }

  @override
  void didUpdateWidget(covariant _SubInvestmentItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incomingName = widget.sub.names.isNotEmpty ? widget.sub.names.first : '';
    if (incomingName != _nameController.text) {
      _nameController.text = incomingName;
    }
    if (widget.sub.ratio != oldWidget.sub.ratio &&
        double.tryParse(_ratioController.text) != widget.sub.ratio) {
      _ratioController.text = widget.sub.ratio.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ratioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double subAmount = widget.parentAmount * (widget.sub.ratio / 100);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: '子类名称',
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: widget.onNameChanged,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: TextField(
              controller: _ratioController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                hintText: '%',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: (val) {
                widget.onRatioChanged(double.tryParse(val) ?? 0.0);
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '￥${subAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.right,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}