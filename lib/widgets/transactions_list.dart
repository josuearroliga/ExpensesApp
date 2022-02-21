import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../main.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: <Widget>[
              Text(
                'No transactions have been found!',
                style: Theme.of(context).textTheme.headline6,
              ),

              //Sized boxes are usually added to add space beetween widgets, they cannot be seen by the user.
              SizedBox(
                height: 10,
              ),

              Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 120,
                  child: Image.asset(
                    'assets/images/empty.png',
                    fit: BoxFit.cover,
                  ))
            ],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                shadowColor: Colors.deepOrange,
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                          //You can also use container here.
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                              child: Text("\$${transactions[index].amount}"))),
                    ),
                    title: Text(transactions[index].title,
                        style: Theme.of(context).textTheme.headline6),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date)),

                    //Adding the option for this buttion to show also text on big devices.
                    trailing: MediaQuery.of(context).size.width > 360
                        ? FlatButton.icon(
                            icon: Icon(Icons.delete),
                            textColor: Theme.of(context).errorColor,
                            onPressed: () => deleteTx(transactions[index].id),
                            label: Text('Delete'),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => deleteTx(transactions[index].id),
                          )),
              );
            },
            itemCount: transactions
                .length, //we need to give the listview the amount of widgets tp render
          );
  }
}
