import 'package:flutter/material.dart';
import '../models/transactions.dart';
import './chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
final List<Transactions> recentTransactions;

Chart(this.recentTransactions);

List <Map<String,Object>> get groupedTransactionsValues{
  return List.generate(7, (index) {

    final weekDay=DateTime.now().subtract(Duration(days:index),);
    
    double total=0.0;
    for(var i=0; i<recentTransactions.length; i++)
    {
      if(recentTransactions[i].date.day == weekDay.day && 
      recentTransactions[i].date.month == weekDay.month && 
      recentTransactions[i].date.year == weekDay.year)
      {
        total+= recentTransactions[i].amount;
      }
    }
  
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': total,
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
}

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                maxSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / maxSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
