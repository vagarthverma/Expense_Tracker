import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses>{

double _total=0.0;

final List<Expense> _registeredExpenses = [
  // Expense(
  //   title: 'Flutter Course',
  //  amount:349, 
  //  date: DateTime.now(),
  //  category: Category.work,
  //  ),
  //  Expense(
  //   title: 'Cinema',
  //   amount: 499,
  //   date: DateTime.now(),
  //  category : Category.leisure
  //  ),
];




void findTotal(){
double _temp = 0;

_registeredExpenses.forEach((element) {
_temp+=element.amount;

 });

_total=_temp;
}

void _openAddExpenseOverlay(){
  showModalBottomSheet(
    isScrollControlled: true,
    context: context, 
    builder:(ctx) => NewExpense(onaddExpense:_addExpense),
  );
}

void _addExpense(Expense expense){
  setState(() {
    _registeredExpenses.add(expense);
    findTotal();
  });
}

void _removeExpense(Expense expense){
  final expenseIndex =_registeredExpenses.indexOf(expense);
  setState((){
    _registeredExpenses.remove(expense);
    findTotal();

  });


  ScaffoldMessenger.of(context).clearSnackBars();
ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration:  const Duration(seconds: 3),
    content: const Text('Expense Deleted.'),
    action: SnackBarAction(
      label: 'Undo', 
    onPressed: (){
      setState(() {
        _registeredExpenses.insert(expenseIndex, expense); 
      });
      },
      ),
    ),
 );
}

  @override
  Widget build(BuildContext context){
    final width= MediaQuery.of(context).size.width;
  
  Widget mainContent = const Center(
    child: Text('No expense found. Start adding some!'),
  );

if (_registeredExpenses.isNotEmpty){
  mainContent = ExpensesList(
          expenses: _registeredExpenses,
          onRemoveExpense: _removeExpense,
          );
      }

  return Scaffold(
    appBar: AppBar(
      title: const Text('Expense Tracker'),
      actions: [
        IconButton(
        onPressed:_openAddExpenseOverlay,
        icon: const Icon(Icons.add),
        ),
      ],
      ),
    body: width < 600
    ?Column(
      children: [
          Chart(expenses: _registeredExpenses),
        Expanded (
          child: mainContent ,
          ),
          SizedBox(height: 10,),
          Container(
            margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      )
      ,child: Center(child: Text("Total ${_total}",style:  TextStyle(color: Colors.white,fontSize: 24),)),
          )
         ],
        )
     : Row(children: [
      Expanded(
        child:  Chart(expenses: _registeredExpenses),
      ),
        Expanded (
          child: mainContent ,
        ),
       ]),
      );
  }
}