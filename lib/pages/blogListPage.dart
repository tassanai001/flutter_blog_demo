import 'package:blog_demo/pages/loginPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/blog.model.dart';
import '../services/blogs.service.dart';
import 'blogDetailPage.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({super.key});

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: prefer_typing_uninitialized_variables
  var _prefs;
  List<BlogModel> _blogList = [];
  final baseUrl = dotenv.env['BASE_URL'];
  static const avatarImage =
      "https://static.vecteezy.com/system/resources/previews/014/194/198/original/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg";

  Future<http.Response> _onInitData() async {
    var response = await BlogService().get('$baseUrl/blogs');
    if (response != null) {
      List<BlogModel> blogList = [];
      for (var i = 0; i < response.length; i++) {
        BlogModel blogItem = BlogModel.fromJson(response[i]);
        blogList.add(blogItem);
      }
      setState(() {
        _blogList = blogList;
      });
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    _onInitData();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });
  }

  _onCreateBlog() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId") ?? "";

    CreateBlogModel newBlog = CreateBlogModel(
      title: _titleController.text,
      author: userId,
      description: _descriptionController.text,
      image: _imageController.text,
    );

    _imageController.clear();
    _titleController.clear();
    _descriptionController.clear();

    await BlogService().post('$baseUrl/blogs', newBlog);
    await _onInitData();
  }

  InputDecoration onGetDecorator({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }

  void _onCreateBlogModal() {
    showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (BuildContext context) {
          return Container(
            color: Theme.of(context).secondaryHeaderColor,
            child: SingleChildScrollView(
              child: SizedBox(
                  child: Center(
                      child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Create Blog',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: _imageController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your image link',
                                ),
                                validator: (String? value) {
                                  if (value == "") {
                                    return 'Please enter image link';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your title',
                                ),
                                validator: (String? value) {
                                  if (value == "") {
                                    return 'Please enter title';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                maxLines: 5,
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your description',
                                ),
                                validator: (String? value) {
                                  if (value == "") {
                                    return 'Please enter description';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () => {
                                if (_formKey.currentState!.validate())
                                  {_onCreateBlog(), Navigator.pop(context)}
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ]),
                ),
              ))),
            ),
          );
        });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  UserAccountsDrawerHeader onGetUserAccountsDrawerHeader() {
    String username = "";
    String name = "";
    String surname = "";

    if (_prefs != null) {
      username = _prefs.getString("username") ?? "";
      name = _prefs.getString("name") ?? "";
      surname = _prefs.getString("surname") ?? "";
    }

    return UserAccountsDrawerHeader(
      accountName: Text('$name $surname'),
      accountEmail: Text(username),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: NetworkImage(avatarImage),
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF875BF7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: _openDrawer,
            child: const CircleAvatar(
              backgroundImage: NetworkImage(avatarImage),
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          // Disable swipe back navigation
          return false;
        },
        child: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: _onInitData,
          child: Container(
            color: Theme.of(context).secondaryHeaderColor,
            child: ListView.builder(
              itemCount: _blogList.length,
              itemBuilder: (context, index) {
                BlogModel blogItem = _blogList[index];
                DateTime toDateTime = DateTime.parse(blogItem.createdAt);
                String createdAt = DateFormat('dd/MM/yyyy').format(toDateTime);

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(4),
                  child: ListTile(
                    onTap: () {
                      if (blogItem.sId != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BlogDetailScreen(blogItem: blogItem);
                        }));
                      }
                    },
                    isThreeLine: true,
                    title: Text(blogItem.title ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        )),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              overflow: TextOverflow.ellipsis,
                              "Author: ${blogItem.author.name} ${blogItem.author.surname}",
                              style: const TextStyle(fontSize: 12)),
                          Text(createdAt, style: const TextStyle(fontSize: 12)),
                        ]),
                    trailing: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Hero(
                        tag: blogItem.sId ?? "",
                        child: Image(
                          image: NetworkImage(blogItem.image ?? ""),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).secondaryHeaderColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              onGetUserAccountsDrawerHeader(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Handle settings menu item
                  // Navigate to settings page or show a dialog
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove("userId");

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _onCreateBlogModal,
        tooltip: 'Create blog',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
