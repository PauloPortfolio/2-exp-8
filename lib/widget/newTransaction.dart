import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptativeFlatButton.dart';

class NewTransaction extends StatefulWidget {
  final Function _createTxDAO;

  NewTransaction(this._createTxDAO);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                onSubmitted: (_) => _submitData(),
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No date'
                          : 'Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                    ),
                    AdaptativeFlatButton('Date', _showDataPicker)
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _submitData,
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                child: Text('Add Transaction'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDataPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((datePicked) {
      if (datePicked == null) return;
      setState(() {
        _selectedDate = datePicked;
      });
    });
  }

  void _submitData() {
    double parsedAmount = double.parse(amountController.text);

    if (titleController.text.isEmpty ||
        amountController.text.isEmpty ||
        parsedAmount <= 0 ||
        _selectedDate == null) {
      return;
    }

    widget._createTxDAO(
      titleController.text,
      double.parse(amountController.text),
      _selectedDate,
    );

    Navigator.of(context).pop();
  }
}
