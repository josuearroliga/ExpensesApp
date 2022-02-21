import 'package:flutter/material.dart';
import '../widgets/chart_bars.dart';
import '../widgets/transactions_list.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  //We need to receive the list of recent transactions and store them somewhere.
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  //creating a getter method
  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      //Which week day am I looking at?
      //To calculate the day we subtract the index to the datetimeNow object.
      //index will be zero the first time and as the list goes ont the index will change and deduct from datetimeNow.
      final weekDay = DateTime.now().subtract(Duration(days: index));
      //Tjis var is declared to store the for loop data for the week day amounts.
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        //Needs to check day, month and year. Only passing weekDay would be incongruent as
        //it has ddmmyy.
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      //We will now pass a metod from the intl class to know the first letter of the day.
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

//Fold allows to change a list to a different type
  double get totalSpending {
    return groupedTransactions.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      //Since the row is the parent of chartbar we can tell row where to positionin the work place.
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((data) {
            //Wrapped the chartbar widget to make the amount label fir its desired space field.
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data["amount"] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
