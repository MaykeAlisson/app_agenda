import 'package:agenda_app/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();


  @override
  void initState() {
    super.initState();

    /*Contact contato = Contact();
    contato.name = "Mayke Alisson";
    contato.email = "maykealison@gmail.com";
    contato.phone = "123456789";
    contato.img = "imgteste";

    helper.saveContact(contato);*/

    helper.getAllContact().then((list){
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
