import '../models/investment.dart';

abstract class IInvestmentRepository {
  Future<List<Investment>> getAllInvestments();
  Future<void> saveInvestment(Investment investment);
  Future<void> deleteInvestment(String id);
  Future<void> saveGlobalTotal(double amount);
  Future<double> getGlobalTotal();
}
