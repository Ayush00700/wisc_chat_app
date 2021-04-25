import 'package:flutter/material.dart';

class DeleteFunction {
  String item;
  Function spinnerCallback;
  Function todo;
  DeleteFunction(this.item, this.todo, this.spinnerCallback);

  void showDialogBox(BuildContext context, int id) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are you sure you want to Delete this $item?'),
            title: Text(
              'Delete $item',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: () {
                  spinnerCallback(true);
                  todo(id);
                  spinnerCallback(false);
                  Navigator.pop(context);
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }
}
