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
  final TextEditingController _totalAmountController = TextEditingController(text: '1000000');
  double _totalAmount = 1000000;

  final List<String> _tools = ['黄金', '国债', '货币基金', '股票'];

  @override
  void dispose() {
    _totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InvestmentProvider>(context);

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
                  setState(() {
                    _totalAmount = double.tryParse(text) ?? 0.0;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // 2. 主表格
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(color: Colors.grey.shade300),
                dataRowMinHeight: 56,
                dataRowMaxHeight: double.infinity,
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('投资工具', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('比例 (%)', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('投资工具子类', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('金额 (￥)', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('操作', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: provider.mainRows.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  final double rowAmount = _totalAmount * (row.ratio / 100);

                  return DataRow(
                    cells: [
                      // 3. 投资工具选择
                      DataCell(
                        DropdownButton<String>(
                          value: _tools.contains(row.name) ? row.name : null,
                          hint: const Text('请选择工具'),
                          underline: const SizedBox(),
                          items: _tools.map((String tool) {
                            return DropdownMenuItem(value: tool, child: Text(tool));
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              provider.updateName(row.id, newValue);
                            }
                          },
                        ),
                      ),

                      // 4. 比例输入框
                      DataCell(
                        SizedBox(
                          width: 80,
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                            ],
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: '0',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            onChanged: (val) {
                              provider.updateRatio(row.id, double.tryParse(val) ?? 0.0);
                            },
                          ),
                        ),
                      ),

                      // 5. 投资工具子类：嵌套无标题子列表
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            width: 380,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ...provider.allInvestments
                                    .where((sub) => sub.parentId == row.id)
                                    .toList()
                                    .asMap().entries.map((subEntry) {
                                  final sub = subEntry.value;
                                  final double subAmount = rowAmount * (sub.ratio / 100);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        // 子工具名称
                                        Expanded(
                                          flex: 4,
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              hintText: '子类名称',
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                            ),
                                            onChanged: (val) {
                                              provider.updateName(sub.id, val);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),

                                        // 子工具比例
                                        SizedBox(
                                          width: 70,
                                          child: TextField(
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                                            ],
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                              hintText: '%',
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                            ),
                                            onChanged: (val) {
                                              provider.updateRatio(sub.id, double.tryParse(val) ?? 0.0);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),

                                        // 子工具自动计算金额
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            '￥${subAmount.toStringAsFixed(2)}',
                                            style: const TextStyle(fontSize: 12),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),

                                        // 删除子工具
                                        IconButton(
                                          icon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () => provider.removeSubTool(sub.id),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () => provider.addSubTool(row.id, '新子类别', 0),
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text('添加子类', style: TextStyle(fontSize: 12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 6. 自动计算总额
                      DataCell(
                        Text(
                          '￥${rowAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),

                      // 行删除操作
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () => provider.removeRow(row.id),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 添加新行按钮
            ElevatedButton.icon(
              onPressed: () => provider.addRow('新工具', 0),
              icon: const Icon(Icons.add),
              label: const Text('添加新行'),
            ),
          ],
        ),
      ),
    );
  }
}
