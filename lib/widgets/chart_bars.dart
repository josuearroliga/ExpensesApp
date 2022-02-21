import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTot;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTot) {
    print('Building chartbar');
  }

  @override
  Widget build(BuildContext context) {
    //Adding this layout builder since this will help us to determin. the height and
    //width of all its childrens, to have a better spacing of the app
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          //Here were calling a stored alue and ading the dollar sign with the help of \
          //To string as fixed tells flutter how many decimal numbers we want.

          //Added a flex fit widget as wrapper in order to make the text get smaller if its to big.
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text('\$${spendingAmount.toStringAsFixed(0)}'))),
          //Add a sized box for spacing.
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          //Main container that has a stack, which allows to have widgets over each other.
          Container(
            height: constraints.maxHeight * 0.6,
            width: 20,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                //A new eidget that allows to rezise itself based on it predecesor widget.
                //You need to pass a parameter, in this case its the variable spendingPctOfTot
                //Which is the variance of a day vs a week.
                FractionallySizedBox(
                  heightFactor: spendingPctOfTot,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ],
            ),
          ),

          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label))),
        ],
      );
    });
    //The columns are the ones that will tell us how much we have spent this day.
  }
}
