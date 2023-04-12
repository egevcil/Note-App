import 'package:noteapp_sqflite/home.dart';
import 'package:noteapp_sqflite/sqldb.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final title,note,id;
  const EditNote({Key? key, this.title, this.note, this.id}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  void initState() {
    title.text = widget.title;
    note.text = widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text("Edit Note",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
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
                  color: Colors.deepOrangeAccent,
                  child: const Text("Edit Note",style: TextStyle(color: Colors.black,fontSize: 17),),
                  onPressed: ()async{
                    int response = await sqlDb.updateData('notes', {
                      'title' : title.text,
                      'note'  : note.text
                    },
                        'id = ${widget.id}'
                    );
                    if(response > 0 ){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (route) => false);
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
        controller: controller,
        decoration: InputDecoration(
          hintText: hintxt,
          prefixIcon: const Icon(Icons.view_headline, color: Colors.deepOrangeAccent,),
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
    );
  }

  Widget noteTextFormField(String hintxt, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintxt,
          prefixIcon: const Icon(Icons.note, color: Colors.deepOrangeAccent,),
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
    );
  }
}