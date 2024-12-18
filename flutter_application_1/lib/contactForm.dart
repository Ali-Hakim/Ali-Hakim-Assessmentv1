import 'package:flutter/material.dart';

class ContactFormPage extends StatefulWidget {
  const ContactFormPage({super.key});

  @override
  _ContactFormPageState createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  bool subscribe = false;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  ContactMethod selectedMethod = methods[0];
  String selectedGender = '';
  String submit = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 10),
            const Text('Name', style: TextStyle(fontSize: 17)),
            SizedBox(
              width: 470,
              height: 60,
              child: TextField(
                controller: _controllerName,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Email', style: TextStyle(fontSize: 17)),
            SizedBox(
              width: 470,
              height: 60,
              child: TextField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                ),
              ),
            ),
            const Text('Gender', style: TextStyle(fontSize: 17)),
            GenderWidget(
              updateGender: (String gender) {
                setState(() {
                  selectedGender = gender;
                });
              },
              method: selectedMethod,
            ),
            const SizedBox(height: 10),
            const Text('Preferred Contact Method', style: TextStyle(fontSize: 17)),
            MyDropdownWidget(
              updateMethod: (ContactMethod method) {
                setState(() {
                  selectedMethod = method;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Checkbox(
                  value: subscribe,
                  onChanged: (value) {
                    setState(() {
                      subscribe = value!;
                    });
                  },
                ),
                const Text(
                  'Subscribe to newsletter',
                  style: TextStyle(fontSize: 17.0),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_controllerName.text.isEmpty ||
                        _controllerEmail.text.isEmpty ||
                        selectedGender.isEmpty) {
                      setState(() {
                        submit = 'Please fill out all fields';
                      });
                    } else {
                      selectedMethod._Name = _controllerName.text;
                      selectedMethod._Email = _controllerEmail.text;
                      selectedMethod.gender = selectedGender;
                      selectedMethod.subscribe = subscribe;
                      setState(() {
                        submit = selectedMethod.getInformation();
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controllerName.clear();
                    _controllerEmail.clear();
                    setState(() {
                      selectedGender = '';
                      selectedMethod = methods[0];
                      subscribe = false;
                      submit = '';
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                submit,
                style: TextStyle(
                  fontSize: 16,
                  color: submit == 'Please fill out all fields' 
                  ? Colors.red 
                  : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<ContactMethod> methods = [
  ContactMethod('Email'),
  ContactMethod('Phone'),
  ContactMethod('SMS')
];

class ContactMethod {
  String method;
  bool subscribe = false;
  String gender = '';
  String _Name = '';
  String _Email = '';

  ContactMethod(this.method);

  @override
  String toString() {
    return '$method';
  }

  String getInformation(){
    return """
    Submitted Information:
    Name: $_Name
    Email: $_Email
    Gender: $gender
    Preferred Contact Method: $method
    Subscribe to newsletter: $subscribe
    """;
  }

  String getSubscribe() {
    return 'Subscribe to newsletter: $subscribe';
  }
}

class MyDropdownWidget extends StatefulWidget {
  const MyDropdownWidget({required this.updateMethod, super.key});
  final Function(ContactMethod) updateMethod;

  @override
  State<MyDropdownWidget> createState() => _MyDropdownWidgetState();
}

class _MyDropdownWidgetState extends State<MyDropdownWidget> {
  ContactMethod selectedMethod = methods[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ContactMethod>(
      value: selectedMethod,
      onChanged: (ContactMethod? method) {
        if (method != null) {
          setState(() {
            selectedMethod = method;
            widget.updateMethod(method);
          });
        }
      },
      items: methods.map<DropdownMenuItem<ContactMethod>>((ContactMethod method) {
        return DropdownMenuItem<ContactMethod>(
          value: method,
          child: Text(method.toString()),
        );
      }).toList(),
    );
  }
}

class GenderWidget extends StatefulWidget {
  const GenderWidget({required this.method, required this.updateGender, super.key});
  final Function(String) updateGender;
  final ContactMethod method;

  @override
  State<GenderWidget> createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.method.gender;
  }

  void _handleGenderChange(String? gender) {
    if (gender != null) {
      setState(() {
        _selectedGender = gender;
        widget.updateGender(gender);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ListTile(
            title: const Text('Male'),
            leading: Radio<String>(
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: _handleGenderChange,
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Female'),
            leading: Radio<String>(
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: _handleGenderChange,
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Other'),
            leading: Radio<String>(
              value: 'Other',
              groupValue: _selectedGender,
              onChanged: _handleGenderChange,
            ),
          ),
        ),
      ],
    );
  }
}
