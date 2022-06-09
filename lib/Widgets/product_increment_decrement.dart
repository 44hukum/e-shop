import 'package:flutter/material.dart';

class ItemCounter extends StatefulWidget {
   @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        children: [
          IconButton(onPressed: ()=>{ _increment()}, icon: Icon(Icons.add)),
          Text(_counter.toString(),style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),),
          IconButton(onPressed: ()=>{ _decrement()}, icon: Icon(Icons.remove))
        ],
      ),
    );
  }

  void _increment() {
    setState(() {
      _counter += 1;
    });
  }
    void _decrement(){
      setState(() {
        _counter -= 1;
      });

  }
}


