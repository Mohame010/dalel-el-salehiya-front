import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UsersAdminScreen extends StatefulWidget {
  @override
  State<UsersAdminScreen> createState() => _UsersAdminScreenState();
}

class _UsersAdminScreenState extends State<UsersAdminScreen> {

  List users = [];
  List filtered = [];

  String selectedRole = "all";
  TextEditingController search = TextEditingController();

  bool loading = true;

  Future fetchUsers() async {
    final data = await ApiService.get("/users");

    setState(() {
      users = data;
      filtered = data;
      loading = false;
    });
  }

  void filterUsers() {
    setState(() {
      filtered = users.where((u) {
        final matchSearch = u["username"]
            .toLowerCase()
            .contains(search.text.toLowerCase());

        final matchRole =
            selectedRole == "all" ? true : u["role"] == selectedRole;

        return matchSearch && matchRole;
      }).toList();
    });
  }

  Future deleteUser(int id) async {
    await ApiService.delete("/delete-user/$id");

    showMsg("Deleted 🔥");
    fetchUsers();
  }

  // 🔥 Add User
  void openAddUser() {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
    String role = "user";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => buildForm(
        title: "Add User",
        username: username,
        password: password,
        role: role,
        onRoleChange: (val) => role = val,
        onSubmit: () async {

          if (username.text.isEmpty || password.text.isEmpty) {
            showMsg("Fill all fields ❌");
            return;
          }

          await ApiService.post(
            "/add-user",
            {
              "username": username.text,
              "password": password.text,
              "role": role,
            },
          );

          showMsg("User Added 🔥");

          Navigator.pop(context);
          fetchUsers();
        },
      ),
    );
  }

  // 🔥 Edit User
  void openEditUser(Map user) {
    TextEditingController username =
        TextEditingController(text: user["username"]);
    String role = user["role"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => buildForm(
        title: "Edit User",
        username: username,
        role: role,
        onRoleChange: (val) => role = val,
        onSubmit: () async {

          await ApiService.put(
            "/update-user/${user["id"]}",
            {
              "username": username.text,
              "role": role,
            },
          );

          showMsg("Updated 🔥");

          Navigator.pop(context);
          fetchUsers();
        },
      ),
    );
  }

  // 🎨 Form
  Widget buildForm({
    required String title,
    required TextEditingController username,
    TextEditingController? password,
    required String role,
    required Function(String) onRoleChange,
    required Function onSubmit,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text(title,
              style: TextStyle(color: Colors.white, fontSize: 20)),

          SizedBox(height: 15),

          buildInput(username, "Username"),

          if (password != null) ...[
            SizedBox(height: 10),
            buildInput(password, "Password"),
          ],

          SizedBox(height: 10),

          DropdownButtonFormField(
            value: role,
            dropdownColor: Colors.black,
            style: TextStyle(color: Colors.white),
            items: [
              DropdownMenuItem(value: "user", child: Text("User")),
              DropdownMenuItem(value: "admin", child: Text("Admin")),
            ],
            onChanged: (val) => onRoleChange(val.toString()),
          ),

          SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onSubmit(),
              child: Text("Save"),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInput(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: openAddUser,
        child: Icon(Icons.add),
      ),

      body: Container(
        decoration: gradient(),
        child: SafeArea(
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Users 👤",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 🔍 Search
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: search,
                  onChanged: (_) => filterUsers(),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // 🎯 Filter
              DropdownButton(
                value: selectedRole,
                dropdownColor: Colors.black,
                items: [
                  DropdownMenuItem(value: "all", child: Text("All")),
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                  DropdownMenuItem(value: "user", child: Text("User")),
                ],
                onChanged: (val) {
                  selectedRole = val.toString();
                  filterUsers();
                },
              ),

              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No Users 😢",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final user = filtered[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(18),
                                    color:
                                        Colors.white.withOpacity(0.1),
                                    border: Border.all(
                                        color: Colors.white24),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      user["username"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      user["role"],
                                      style:
                                          TextStyle(color: Colors.white70),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () =>
                                              openEditUser(user),
                                        ),

                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              deleteUser(user["id"]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration gradient() => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff0f2027),
            Color(0xff203a43),
            Color(0xff2c5364),
          ],
        ),
      );
}