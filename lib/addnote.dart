import 'package:flutter/material.dart';
import 'package:noteapp_sqflite/home.dart';
import 'package:noteapp_sqflite/sqldb.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text("Creating new note",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: formkey,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.all(10),
                child: titleTextFormField("Enter a title",title)
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: noteTextFormField("Enter a note",note)
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: MaterialButton(
                  color: Colors.orange,
                  child: const Text("Add Note",style: TextStyle(color: Colors.black,fontSize: 17),),
                  onPressed: ()async{
                    int response = await sqlDb.insertData('notes', {
                      'title' : title.text,
                      'note'  : note.text
                    });
                    if(response > 0 ){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      const Home()), (route) => false);
                    }else{
                      print("failed");
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget titleTextFormField(String hintxt, TextEditingController controller) {
    return TextFormField(
        controller: title,
        decoration: InputDecoration(
          hintText: hintxt,
          prefixIcon: const Icon(Icons.view_headline, color: Colors.deepOrangeAccent),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1,
                  color: Colors.orange
              ),
              borderRadius: BorderRadius.circular(13)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.orange
              ),
              borderRadius: BorderRadius.circular(13)
          ),
        ),
        validator: (value) {
          if (value != title.text) {
            return "Title field is empty";
          } else {
            return null;
          }
        }
    );
  }

  Widget noteTextFormField(String hintxt, TextEditingController controller) {
    return TextFormField(
        controller: note,
        decoration: InputDecoration(
          hintText: hintxt,
          prefixIcon: const Icon(Icons.note, color: Colors.deepOrangeAccent),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1,
                  color: Colors.orange
              ),
              borderRadius: BorderRadius.circular(13)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.orange
              ),
              borderRadius: BorderRadius.circular(13)
          ),
        ),
        validator: (value) {
          if (value != note.text) {
            return "Note field is empty";
          } else {
            return null;
          }
        }
    );
  }
}