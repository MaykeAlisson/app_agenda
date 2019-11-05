import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColunm = "idColunm";
final String nameColunm = "nameColunm";
final String emailColunm = "emailColunm";
final String phoneColunm = "phoneColunm";
final String imgColunm = "imgColunm";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColunm INTEGER PRIMARY KEY, $nameColunm TEXT, $emailColunm TEXT,"
          "$phoneColunm TEXT, $imgColunm TEXT)");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db; // conecta ao banco
    contact.id = await dbContact.insert(contactTable, contact.toMap()); // query
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db; // conecta ao banco de dados
    // query
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColunm, nameColunm, emailColunm, phoneColunm, imgColunm],
        where: "$idColunm = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db; // conecta ao banco de dados
    return await dbContact
        .delete(contactTable, where: "$idColunm = ?", whereArgs: [id]); // query
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db; // conecta ao banco de dados
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idColunm = ?", whereArgs: [contact.id]); // query
  }

  Future<List> getAllContact() async {
    Database dbContact = await db; // conecta ao banco de dados
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable"); // query
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db; // conecta ao banco de dados
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database dbContact = await db; // conecta ao banco de dados
    await dbContact.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact.fromMap(Map map) {
    id = map[idColunm];
    name = map[nameColunm];
    email = map[emailColunm];
    phone = map[phoneColunm];
    img = map[imgColunm];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColunm: name,
      emailColunm: email,
      phoneColunm: phone,
      imgColunm: img
    };

    if (id != null) {
      map[idColunm] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, nome: $name, email: $email, phone: $phone, img: $img)";
  }
}
