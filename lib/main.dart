import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transactions_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Adding the cupertino material app challenge
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
          fontFamily: 'Montserrat',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black54,
              ),
              button: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//Adding widgetbinding to check the app life spana nd different states.
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //Importing the data from the user_transaction class since we need to use it wihtout sending any arguments here.
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 'n1', title: 'Fist item', amount: 29.99, date: DateTime.now()),
  ];

//Starts monitoring the app states.
//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//     print('Initstate works!');
//   }

// //Chrcks on the actual app lifecycle snd allows you to react to them.
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     print(state);
//   }

// //Closes all the comunications and observers that could be ongoing.
//   @override
//   dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

  //We will create the list of recent transaction in this List.
  List<Transaction> get _recentTransactions {
    //Using the 'where' method that allows you to go through a list and
    //return true if found to add in the new list.
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
      //We try to identifu which transactions where made before a week from now.
    }).toList();
  }

  //We pass the date form dtpicker from new transactio to tyis function by adding the new parameter and
  //changing the date value.
  void _addNewTransaction(
      String Txtitle, double Txamount, DateTime chosenDate) {
    final newTx = Transaction(
        title: Txtitle,
        amount: Txamount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  //*Ading a delete method by passing the id for the fiel were looking for.
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

//We start creating the pop up widget to add the transaction details.
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  //Creating builders for the cupertino checkout
  Widget _checkCupertino(PreferredSizeWidget appBar, SafeArea pageBody) {
    return CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,
    );
  }

  Widget _checkAndroid(PreferredSizeWidget appBar, SafeArea pageBody) {
    return Scaffold(
      appBar: appBar,
      body: pageBody,

      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, //Adding a floating button to the app
      //Adding the platform check option to check, if is iOS it must behave differently.
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
    );
  }

  //Saving the appbar data here, inside a builder.
  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Expenses App',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              //This is an important property of Row, you can set a min elasticity and this will
              //make it fit on the screen width.
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Expenses App'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add), //Adding a button int the appbar
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
  }

  //Builder for the body
  Widget _buildBody(PreferredSizeWidget appBar) {
    return SafeArea(
      child: SingleChildScrollView(
        //We need to wrap our contaoner inside this widget to scroll items.
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: TransactionList(_userTransactions, _deleteTransaction))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Saving the app bar as a variable to manipulate its attributes.
    //Also check if its iOS to present a different appBar
    final PreferredSizeWidget appBar = _buildAppBar();

    //Saving body into a variable to use in cupertino and Andorid look.
    final pageBody = _buildBody(appBar);

    return Platform.isIOS
        ? _checkCupertino(appBar, pageBody)
        : _checkAndroid(appBar, pageBody);
  }
}
