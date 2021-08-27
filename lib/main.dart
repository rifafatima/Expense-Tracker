import 'package:flutter/material.dart';
import './widgets/new_transactions.dart';

import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transactions.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans', 
          fontSize: 18,
          fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            color:Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
          fontFamily: 'OpenSans', 
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
          ),
          ),

      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override 

  MyHomePageState createState() => MyHomePageState();
}


 
 class MyHomePageState extends State<MyHomePage>{

final List<Transactions> userTransactions=[

    /* Transactions(title: 'food',
    amount:100.00,
    date: DateTime.now(),
   id:DateTime.now().toString(),
    ),
    Transactions(title: 'books',
    amount:250.00,
    date: DateTime.now(),
   id:DateTime.now().toString(),
    ), */
  ];

bool showChart=false;

List<Transactions> get _recentTransactions{
  return userTransactions.where((tx) {
    return tx.date.isAfter(DateTime.now().subtract(Duration(days:7),
    ),
    );
  }).toList();
}

void addNewTransaction(String newtitle, double newamount, DateTime chosenDate)
{
final newTx=Transactions(title:newtitle, 
amount: newamount, 
date:chosenDate, 
id:DateTime.now().toString(),
);

setState(() {
  userTransactions.add(newTx);
});
}

  void startAddNewTransaction(BuildContext ctx){    //process for adding a new transaction
showModalBottomSheet(context: ctx, builder: (_){
   return GestureDetector(
     onTap: () {},
     child: NewTransaction(addNewTransaction),
     behavior: HitTestBehavior.opaque,
);
},
);
  }


void deleteTransaction(String id){
  setState(() {
      userTransactions.removeWhere((tx) => tx.id==id);
    });
}

//String titleInput;
//String amountInput;


  @override
  Widget build(BuildContext context) {

   final mediaQuery= MediaQuery.of(context);  //recommended, efficient
   final isLandscape = mediaQuery.orientation==Orientation.landscape;

    final appBar = AppBar(
        title: Text('Expense Tracker'),
        actions: <Widget>[
          IconButton(icon:Icon(Icons.add), 
          onPressed: ()=> startAddNewTransaction(context),
          ),
        ],
      );

final txListWidget=Container(
        height:(mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top) *0.7,
        child: 
      TransactionList(userTransactions,deleteTransaction),
      );

    return Scaffold(
      appBar: appBar,
      body:SingleChildScrollView(child:
       Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:CrossAxisAlignment.stretch,
        children:<Widget>[
        if(isLandscape )
         Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text('Show chart'),
            Switch(
              value: showChart,
              onChanged: (val){
                setState(() {
                  showChart=val;
                  });
              },
            ),
          ],),

         if(!isLandscape)
         Container(
          height:(mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top) *0.7,
          child: Chart(_recentTransactions),
          ), 
          if(!isLandscape) txListWidget,
          
          if(isLandscape)
        showChart ? Container(
          height:(mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top) *0.7,
          child: Chart(_recentTransactions),
          ) 
          :txListWidget
      
      ],
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=> startAddNewTransaction(context),
        ) ,
    );
  }
}
 