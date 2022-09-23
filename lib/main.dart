import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:human_resources/model.dart';

void main() {
  runApp(const MyApp());
}
const titleStyle = TextStyle(fontSize: 20);
const subTitleStyle = TextStyle(fontSize: 18);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }}


class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key}) : super(key: key);
  final String title='';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final url = Uri.parse('https://reqres.in/api/users');
  var personalResult;
  int counter = 0;
  Future callPerson() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var result = personalFromJson(response.body);
        print(result.data[0].avatar);
        print(result.data[0].email);
        print(result.data[0].firstName);
        print(result.data[0].lastName);
        if (mounted) {
          setState(() {
            counter = result.data.length;
            personalResult = result;
          });
        }
        return result;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    callPerson();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Human Resources'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: counter != null
                ? ListView.builder(
                itemCount: counter,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      personalResult.data[index].firstName +
                          ' ' +
                          personalResult.data[index].lastName,
                      style: titleStyle,
                    ),
                    subtitle: Text(
                      personalResult.data[index].email,
                      style: subTitleStyle,
                    ),
                    leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(personalResult.data[index].avatar),
                    ),
                  );
                })
                : const Center(child: CircularProgressIndicator())),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        backgroundColor: Colors.orange,
        onPressed: () {
          callPerson();
        },
      ),
    );
  }
}