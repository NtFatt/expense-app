import 'package:expense_app/features/categories/domain/category_model.dart';
import 'package:expense_app/features/transactions/domain/transaction_type.dart';

const List<CategoryModel> expenseCategories = <CategoryModel>[
  CategoryModel(
    id: 'expense_food',
    name: 'Ăn uống',
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'expense_transport',
    name: 'Di chuyển',
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'expense_shopping',
    name: 'Mua sắm',
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'expense_study',
    name: 'Học tập',
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'expense_fun',
    name: 'Giải trí',
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'expense_bills',
    name: 'Hóa đơn',
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'expense_other',
    name: 'Khác',
    type: TransactionType.expense,
  ),
];

const List<CategoryModel> incomeCategories = <CategoryModel>[
  CategoryModel(
    id: 'income_salary',
    name: 'Lương',
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'income_bonus',
    name: 'Thưởng',
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'income_allowance',
    name: 'Phụ cấp',
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'income_investment',
    name: 'Đầu tư',
    type: TransactionType.income,
  ),
  CategoryModel(id: 'income_other', name: 'Khác', type: TransactionType.income),
];

List<CategoryModel> defaultCategoriesForType(TransactionType type) {
  return type.isExpense ? expenseCategories : incomeCategories;
}
