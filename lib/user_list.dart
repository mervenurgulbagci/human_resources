import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/model.dart';

class UserListPage extends StatefulWidget {
   const UserListPage({Key? key}) : super(key: key);
   @override
   State<StatefulWidget> createState() =>_UserListPageState();
   }
class _UserListPageState extends State<UserListPage>
{

  final url = Uri.parse('https://reqres.in/api/users');
  var personalResult;
  int counter = 0;

  TextStyle titleStyle = const TextStyle(fontSize: 20);
  TextStyle subTitleStyle = const TextStyle(fontSize: 18);


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
        actions: [
          IconButton(
              onPressed: () {
                //logout
              },
              icon: const Icon(Icons.logout_rounded))
        ],
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
    );
  }
}