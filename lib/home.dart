import 'package:noteapp_sqflite/editnote.dart';
import 'package:noteapp_sqflite/sqldb.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  SqlDb sqlDb = SqlDb();
  List mynotes = [];
  bool isLoading = true;

  Future readdata() async {
    List<Map> response = await sqlDb.readData(" notes ");
    mynotes.addAll(response);
    isLoading = false;
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    readdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add,color: Colors.black),
            onPressed: (){
              Navigator.of(context).pushNamed("addnote");
            }
        ),
        appBar: AppBar(
          title: const Text("My Notes",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
          backgroundColor: Colors.deepOrangeAccent,
          toolbarHeight: 90,
          elevation: 0,
        ),
        body: isLoading == true
            ? const Center(child: CircularProgressIndicator(),)
            : ListView(
            children: [
              ListView.builder(
                  itemCount: mynotes.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: ((BuildContext context,int i) {
                    return Card(
                      child: ListTile(
                          title: Text("${mynotes[i]['title']}"),
                          subtitle: Text("${mynotes[i]['note']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: ()async{
                                    int response = await sqlDb.deleteData('notes', 'id = ${mynotes[i]['id']}');
                                    if(response >0){
                                      mynotes.removeWhere((element) => element['id'] == mynotes[i]['id']);
                                      setState(() {});
                                    }
                                  },
                                  icon: const Icon(Icons.delete,color: Colors.orange)
                              ),
                              IconButton(
                                  onPressed: ()async{
                                    Navigator.of(context).push(MaterialPageRoute(builder: ((context) =>  EditNote(
                                        id: mynotes[i]['id'],
                                        title: mynotes[i]['title'],
                                        note: mynotes[i]['note']
                                    ))));
                                  },
                                  icon: const Icon(Icons.edit,color: Colors.orange)
                              )
                            ],
                          )
                      ),
                    );
                  }))
            ]
        )
    );
  }
}