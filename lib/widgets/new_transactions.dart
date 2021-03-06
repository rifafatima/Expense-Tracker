import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

NewTransaction(this.addTx);

@override
_NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

 final titleController=TextEditingController();
 final amountController=TextEditingController();
 DateTime _selectedDate;
 

void submitData(){
  if(amountController.text.isEmpty)
  {
    return;
  }

  final enteredTitle=titleController.text;
  final enteredAmount=double.parse(amountController.text);

  if(enteredTitle.isEmpty || enteredAmount <=0 || _selectedDate==null){
    return;
  }

  widget.addTx(
   enteredTitle,
   enteredAmount,
   _selectedDate,
   );

   Navigator.of(context).pop();
}

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
          elevation: 5,
          child: Container( 
           padding:EdgeInsets.only(
             top: 10, 
           left:10, 
           right:10, 
           bottom: MediaQuery.of(context).viewInsets.bottom +10,
           ),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.end,
            children: <Widget>[
            TextField(decoration:InputDecoration(labelText: 'Title' ),
            controller: titleController,
            onSubmitted: (_)=> submitData(),

            //onChanged: (val) {
             // titleInput=val;
            //},
            ),
            TextField(
            decoration:InputDecoration(labelText: 'Amount' ) ,
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),//for ios this format is needed
            onSubmitted: (_)=> submitData(),
            
            //onChanged: (val) {
             // amountInput=val;
            //},
            ),

          Container(
            height: 70,
            child: Row(children: <Widget>[
            Expanded(
              child: Text(_selectedDate==null
            ?'No date chosen' 
            :'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
            ),
              ),

            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('Choose date!', 
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              ), 
              onPressed: _presentDatePicker,
            ),
          ],),
          ),

            RaisedButton(child: Text('Add Transaction'),
            color:Theme.of(context).primaryColor, 
            textColor: Theme.of(context).textTheme.button.color,
            onPressed: submitData,  //won't get a value here, so no argument
            ),
          ],
          ),
          ),
        );
  }
}
