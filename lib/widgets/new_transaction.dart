import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titlecontroler = TextEditingController();

  final valuecontroller = TextEditingController();

  DateTime _selectedDate;

  //Function thata works as the submit button.
  void submitData() {
    final enteredTitle = titlecontroler.text;
    final enteredValue = double.parse(valuecontroller.text);

    if (enteredTitle.isEmpty || enteredValue <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredValue,
        _selectedDate //Now we go to the main class since there we have the add function.
        );

    Navigator.of(context).pop();
  }

//Creating a method that will help us to bring up a date picker box and store the selected date.
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Wrap the card widget into a SinglechildSV so the user can scroll when the Sf Key is up
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              //Using mediaquery to determine the space the bottom card is using.
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              top: 10,
              left: 10,
              right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: titlecontroler,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                controller: valuecontroller,
                onSubmitted: (_) => submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No date chosen!'
                            : 'Picked date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    //Crated a widget that contains this code to simplify the app.
                    AdaptiveFlatButton('Choose date', _presentDatePicker)
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton.filled(
                      // alignment: Alignment.centerLeft,

                      child: Text('Add transaction'),
                      onPressed: submitData,
                    )
                  : ElevatedButton(
                      child: Text('Add transaction'),
                      onPressed: submitData,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
