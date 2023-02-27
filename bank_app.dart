import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';

void main() {
  Customers customer = Customers();
  var admin = Admin();
  var staff = Staff();
  print('Welcome to Ghost Bank!');
  print('Kindly confirm how you wil like to login');
  print('Enter "1" as a Customer');
  print('Enter "2" as a Staff');
  print('Enter "3" as the admin');
  int value = int.parse(stdin.readLineSync()!);

  if (value == 1) {
    customer.enterdetails();
  } else if (value == 2) {
    staff.staffLogin();
  } else if (value == 3) {
    admin.enterdetails();
  }
  // printLine();

  // Sample logins for staff and customers
}

class Customers {
  String? surName;
  String? firstName;
  String? middleName;
  String? accountNumber;
  String? age;
  String? balance;
  String? phoneNumber;
  String? accountType;
  String? pin;

  Customers(
      {this.accountNumber,
      this.accountType,
      this.age,
      this.balance,
      this.firstName,
      this.middleName,
      this.phoneNumber,
      this.pin,
      this.surName});
//Get customer acc number and password for login
  var customerLoggedIn = true;
  var customer = true;
  void getAcc(String acc, String pas) {
    // Customers customer = Customers();

    var filePath = 'customers.csv';

    // Replace this with the content you want to search for
    var searchTerm = acc;
    var file = File(filePath);
    var lines = file.readAsLinesSync(encoding: utf8);

    var matchingRows = [];
//reading each lines of the csv file to check for account number
    for (var line in lines) {
      if (line.contains(searchTerm)) {
        var columns = line.split(',');
        matchingRows.add(columns);
      }
    }
    //print(matchingRows[0][5]);
    accountNumber = matchingRows[0][7];
    accountType = matchingRows[0][6];
    age = matchingRows[0][4];
    balance = matchingRows[0][8];
    firstName = matchingRows[0][1];
    surName = matchingRows[0][0];
    middleName = matchingRows[0][2];
    phoneNumber = matchingRows[0][3];
    pin = matchingRows[0][5];
    while (customer) {
      if (pas == pin) {
        // customerLoggedIn = false;
        print('Welcome $surName');

        print('Enter "1" to view your balance');
        print('Enter "2" to withdraw');
        print('Enter "3" to transfer to a friend');
        print('Enter 4 to logout');
        String val = stdin.readLineSync()!;

        switch (val) {
          case '1':
            print('Your balance is ${balan()}');
            print('What else will you like to do?');
            break;
          case '2':
            print('Enter the amount you will like to withdraw');
            String val = stdin.readLineSync()!;
            withdraw(balance!, val);
            break;
          case '3':
            print('Enter the account number you will like to transfer to');
            String to = stdin.readLineSync()!;
            print('Enter the amount you will like to transfer');
            String h = stdin.readLineSync()!;
            transfer(to, accountNumber!, h);

            break;
          case '4':
            customer = false;
            customerLoggedIn = false;
            break;
          default:
        }
      } else {
        print(
            'You dont have an account with us or you have inputed the wrong details');
        customer = false;
      }
    }
  }

  void transfer(String friend, String a, String add) {
    var check = withdraw(a, add);
    if (check == true) {
      var filePath = 'customers.csv';
      var searchTerm = friend;
      var file = File(filePath);
      var lines = file.readAsLinesSync(encoding: utf8);

      var matchingRows = [];
//reading each lines of the csv file to check for account number
      for (var line in lines) {
        if (line.contains(searchTerm)) {
          var columns = line.split(',');
          matchingRows.add(columns);
        }
      }

      //print(matchingRows[0][5]);
      accountNumber = matchingRows[0][7];
      accountType = matchingRows[0][6];
      age = matchingRows[0][4];
      balance = matchingRows[0][8];
      firstName = matchingRows[0][1];
      surName = matchingRows[0][0];
      middleName = matchingRows[0][2];
      phoneNumber = matchingRows[0][3];
      pin = matchingRows[0][5];

      double amount = double.parse(add);
      double newBalance = double.parse(balance!);
      newBalance = amount + newBalance;
      balance = newBalance.toString();
// read and fetch the customer with the specified account number
      a = accountNumber!;
      filePath = 'customers.csv';

      // Replace this with the content you want to search for
      searchTerm = a;
      file = File(filePath);
      lines = file.readAsLinesSync(encoding: utf8);

      matchingRows = [];
//Save the list of the customers details in an empty list
      for (var line in lines) {
        if (line.contains(searchTerm)) {
          var columns = line.split(',');
          matchingRows.add(columns);
        }
      }
      if (matchingRows.isEmpty) {
        print('This account does not exist!');
        return;
      }

      //go back to the csv file and replace the customer details with the newly inputed details
      int i = 0;
      for (var line in lines) {
        if (line.contains(searchTerm)) {
          final rowUpadate = i;
          final row = lines[rowUpadate].split(',');
          row[0] = surName!;
          row[1] = firstName!;
          row[2] = middleName!;
          row[3] = phoneNumber!;
          row[4] = age!;
          row[5] = pin!;
          row[6] = accountType!;
          row[7] = accountNumber!;
          row[8] = balance!;
          //print(row);

          lines[rowUpadate] = row.join(',');
          file.writeAsStringSync(lines.join('\n'));

          // var columns = line.split(',');
          // matchingRows.add(columns);
        }
        i += 1;
        // print(i);
      }
    } else {
      print('Kidnly deposit first');
      customer = false;
      customerLoggedIn = false;
    }

    customer = false;
    customerLoggedIn = false;
  }

  void deposit() {
    print('Enter the amount you will like to deposit');
    int amount = int.parse(stdin.readLineSync()!);
    int newBalance = int.parse(balance!);
    newBalance = amount + newBalance;
    balance = newBalance.toString();
  }

  void updatebal(String a, String add) {
    //Take in the deposit value and convert to integer
    double amount = double.parse(add);
    double newBalance = double.parse(balance!);
    newBalance = amount + newBalance;
    balance = newBalance.toString();
// read and fetch the customer with the specified account number
    a = accountNumber!;
    var filePath = 'customers.csv';

    // Replace this with the content you want to search for
    var searchTerm = a;
    var file = File(filePath);
    var lines = file.readAsLinesSync(encoding: utf8);

    var matchingRows = [];
//Save the list of the customers details in an empty list
    for (var line in lines) {
      if (line.contains(searchTerm)) {
        var columns = line.split(',');
        matchingRows.add(columns);
      }
    }

    //go back to the csv file and replace the customer details with the newly inputed details
    int i = 0;
    for (var line in lines) {
      if (line.contains(searchTerm)) {
        final rowUpadate = i;
        final row = lines[rowUpadate].split(',');
        row[0] = surName!;
        row[1] = firstName!;
        row[2] = middleName!;
        row[3] = phoneNumber!;
        row[4] = age!;
        row[5] = pin!;
        row[6] = accountType!;
        row[7] = accountNumber!;
        row[8] = balance!;
        // print(row);

        lines[rowUpadate] = row.join(',');
        file.writeAsStringSync(lines.join('\n'));

        // var columns = line.split(',');
        // matchingRows.add(columns);
      }
      i += 1;
      //print(i);
    }
  }

  bool withdraw(String a, String add) {
    //Take in the deposit value and convert to integer
    double amount = double.parse(add);
    double newBalance = double.parse(balance!);
    if (amount > newBalance) {
      print('You do not have sufficient amount to make this transaction');
      return false;
    } else {
      newBalance = newBalance - amount;
      balance = newBalance.toString();
// read and fetch the customer with the specified account number
      a = accountNumber!;
      var filePath = 'customers.csv';

      // Replace this with the content you want to search for
      var searchTerm = a;
      var file = File(filePath);
      var lines = file.readAsLinesSync(encoding: utf8);

      var matchingRows = [];
//Save the list of the customers details in an empty list
      for (var line in lines) {
        if (line.contains(searchTerm)) {
          var columns = line.split(',');
          matchingRows.add(columns);
        }
      }

      //go back to the csv file and replace the customer details with the newly inputed details
      int i = 0;
      for (var line in lines) {
        if (line.contains(searchTerm)) {
          final rowUpadate = i;
          final row = lines[rowUpadate].split(',');
          row[0] = surName!;
          row[1] = firstName!;
          row[2] = middleName!;
          row[3] = phoneNumber!;
          row[4] = age!;
          row[5] = pin!;
          row[6] = accountType!;
          row[7] = accountNumber!;
          row[8] = balance!;
          //print(row);

          lines[rowUpadate] = row.join(',');
          file.writeAsStringSync(lines.join('\n'));

          // var columns = line.split(',');
          // matchingRows.add(columns);
        }
        i += 1;
        //print(i);
      }
    }
    return true;
  }

  String? balan() /**this returns balance of the customer*/ {
    return balance;
  }

  void enterdetails() {
    print('Do you have an account with us? if yes, Enter "1" to login');
    print('Else, enter "2" to signup');
    int value = int.parse(stdin.readLineSync()!);

    if (value == 1) {
      print('Login Page');
      while (customerLoggedIn) {
        customer = true;
        print('Enter your Account Number');
        String accNum = stdin.readLineSync()!;
        print('Enter your password');
        String pass = stdin.readLineSync()!;

        // getAcc(accNum);

        getAcc(accNum, pass);
      }
    } else if (value == 2) {
      signUp();
    }
  }

  void signUp() {
    print('Sign Up page');
    print('Enter your Surname');
    String surName = stdin.readLineSync()!;
    print('Enter your Firstname');
    String firstName = stdin.readLineSync()!;
    print('Enter your Middlename');
    String middleName = stdin.readLineSync()!;
    print('Enter your phone number');
    int phoneNumber = int.parse(stdin.readLineSync()!);
    print('Enter your age');
    int age = int.parse(stdin.readLineSync()!);
    while (true) {
      print('Enter your password');
      String pin = stdin.readLineSync()!;
      print('Verify your password');
      String verifyPassword = stdin.readLineSync()!;
      int bal = 0;
      if (pin == verifyPassword) {
        print('What type of account do you want to open?');
        print('Enter "1" for savings and "2" for current');
        String type;
        String acctype = stdin.readLineSync()!;
        //creating acc type
        if (acctype == "1") {
          type = 'Savings';
        } else {
          type = 'Curent';
        }
        //Creating pin
        var ps = Random();
        List numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
        List pre = [];
        for (int i = 0; i < 10; i++) {
          var d = ps.nextInt(numbers.length);
          pre.add(numbers[d]);
        }
        accountNumber = pre.join("");

        File newCsv = File('customers.csv');
        if (newCsv.existsSync()) {
          newCsv.writeAsStringSync(
              '\n $surName,$firstName,$middleName,$phoneNumber,$age,$pin,$type,$accountNumber, $bal',
              mode: FileMode.append);
        } else {
          newCsv.writeAsStringSync(
              'Surname, Firstname, Middlename, Phone, Age, Password, Account Type, Account Number, Balance',
              mode: FileMode.append);
          newCsv.writeAsStringSync(
              '\n $surName,$firstName,$middleName,$phoneNumber,$age,$pin,$type,$accountNumber,$bal',
              mode: FileMode.append);
        }
        break;
      } else {
        print('Password verification failed');
      }
    }
  }
}

class Staff {
  String? name;
  String? email;
  String? password;
  String suspension = 'false';
  String defaultP = 'true';

  Staff({this.name, this.email, this.password});
  var customer = Customers();

  void createLogin() {
    print('Login created for $name');
    print('Email: $email');
    print('Password: $password');
  }

  void updatebal(String a, String add) {
    //Take in the deposit value and convert to integer
    var filePath = 'customers.csv';

    // Replace this with the content you want to search for
    var searchTerm = a;
    var file = File(filePath);
    var lines = file.readAsLinesSync(encoding: utf8);

    var matchingRows = [];
//reading each lines of the csv file to check for account number
    for (var line in lines) {
      if (line.contains(searchTerm)) {
        var columns = line.split(',');
        matchingRows.add(columns);
      }
    }
    //print(matchingRows[0][5]);
    customer.accountNumber = matchingRows[0][7];
    customer.accountType = matchingRows[0][6];
    customer.age = matchingRows[0][4];
    customer.balance = matchingRows[0][8];
    customer.firstName = matchingRows[0][1];
    customer.surName = matchingRows[0][0];
    customer.middleName = matchingRows[0][2];
    customer.phoneNumber = matchingRows[0][3];
    customer.pin = matchingRows[0][5];

    double amount = double.parse(add);
    double newBalance = double.parse(customer.balance!);
    newBalance = amount + newBalance;
    customer.balance = newBalance.toString();

// read and fetch the customer with the specified account number
    a = customer.accountNumber!;
    filePath = 'customers.csv';

    // Replace this with the content you want to search for
    searchTerm = a;
    file = File(filePath);
    lines = file.readAsLinesSync(encoding: utf8);

    matchingRows = [];
//Save the list of the customers details in an empty list
    for (var line in lines) {
      if (line.contains(searchTerm)) {
        var columns = line.split(',');
        matchingRows.add(columns);
      }
    }

    //go back to the csv file and replace the customer details with the newly inputed details
    int i = 0;
    for (var line in lines) {
      if (line.contains(searchTerm)) {
        final rowUpadate = i;
        final row = lines[rowUpadate].split(',');
        row[0] = customer.surName!;
        row[1] = customer.firstName!;
        row[2] = customer.middleName!;
        row[3] = customer.phoneNumber!;
        row[4] = customer.age!;
        row[5] = customer.pin!;
        row[6] = customer.accountType!;
        row[7] = customer.accountNumber!;
        row[8] = customer.balance!;
        //print(row);

        lines[rowUpadate] = row.join(',');
        file.writeAsStringSync(lines.join('\n'));

        // var columns = line.split(',');
        // matchingRows.add(columns);
      }
      i += 1;
      // print(i);
    }
    print('What else will you like to do?');
  }

  void transfer(friend, a, add) {
    var filePath = 'customers.csv';

    // Replace this with the content you want to search for
    var searchTerm = a;
    var file = File(filePath);
    var lines = file.readAsLinesSync(encoding: utf8);

    var matchingRows = [];
//reading each lines of the csv file to check for account number
    for (var line in lines) {
      if (line.contains(searchTerm)) {
        var columns = line.split(',');
        matchingRows.add(columns);
      }
    }
    //print(matchingRows[0][5]);
    customer.accountNumber = matchingRows[0][7];
    customer.accountType = matchingRows[0][6];
    customer.age = matchingRows[0][4];
    customer.balance = matchingRows[0][8];
    customer.firstName = matchingRows[0][1];
    customer.surName = matchingRows[0][0];
    customer.middleName = matchingRows[0][2];
    customer.phoneNumber = matchingRows[0][3];
    customer.pin = matchingRows[0][5];
    var check = customer.withdraw(a, add);
    if (check == true) {
      filePath = 'customers.csv';

      // Replace this with the content you want to search for
      searchTerm = friend;
      file = File(filePath);
      lines = file.readAsLinesSync(encoding: utf8);

      matchingRows = [];
//reading each lines of the csv file to check for account number
      for (var line in lines) {
        if (line.contains(searchTerm)) {
          var columns = line.split(',');
          matchingRows.add(columns);
        }
      }
      //print(matchingRows[0][5]);
      customer.accountNumber = matchingRows[0][7];
      customer.accountType = matchingRows[0][6];
      customer.age = matchingRows[0][4];
      customer.balance = matchingRows[0][8];
      customer.firstName = matchingRows[0][1];
      customer.surName = matchingRows[0][0];
      customer.middleName = matchingRows[0][2];
      customer.phoneNumber = matchingRows[0][3];
      customer.pin = matchingRows[0][5];

      double amount = double.parse(add);
      double newBalance = double.parse(customer.balance!);
      newBalance = amount + newBalance;
      customer.balance = newBalance.toString();
// read and fetch the customer with the specified account number
      a = customer.accountNumber!;
      filePath = 'customers.csv';

      // Replace this with the content you want to search for
      searchTerm = a;
      file = File(filePath);
      lines = file.readAsLinesSync(encoding: utf8);

      matchingRows = [];
//Save the list of the customers details in an empty list
      for (var line in lines) {
        if (line.contains(searchTerm)) {
          var columns = line.split(',');
          matchingRows.add(columns);
        }
      }

      //go back to the csv file and replace the customer details with the newly inputed details
      int i = 0;
      for (var line in lines) {
        if (line.contains(searchTerm)) {
          final rowUpadate = i;
          final row = lines[rowUpadate].split(',');
          row[0] = customer.surName!;
          row[1] = customer.firstName!;
          row[2] = customer.middleName!;
          row[3] = customer.phoneNumber!;
          row[4] = customer.age!;
          row[5] = customer.pin!;
          row[6] = customer.accountType!;
          row[7] = customer.accountNumber!;
          row[8] = customer.balance!;

          lines[rowUpadate] = row.join(',');

          file.writeAsStringSync(lines.join('\n'));

          // var columns = line.split(',');
          // matchingRows.add(columns);
        }
        i += 1;
        //print(i);
      }
    } else {
      print('You do not have enough balance to perform this operation');
    }

    print('What else will you like to do?');
  }

  var isLogged = true;
  void staffLogin() {
    while (isLogged) {
      print('Login page');
      print('Enter your email');
      String user = stdin.readLineSync()!;
      print('Enter your password');
      String pass = stdin.readLineSync()!;

      File staffCsv = File('Staff.csv');
      var matchinRows = [];
      var lines = staffCsv.readAsLinesSync(encoding: utf8);

      for (var line in lines) {
        if (line.contains(user)) {
          var columns = line.split(',');
          matchinRows.add(columns);
        }
      }
      if (pass == matchinRows[0][2]) {
        if (matchinRows[0][3] == 'true') {
          print('Your account has been suspended, kindly report to HR');
          return;
        } else if (matchinRows[0][4] == 'true') {
          print(
              'As a new staff, you will need to change your default password');
          var verify = true;
          while (verify) {
            print('Enter your new password');
            var newP = stdin.readLineSync()!;
            print('Verify your password');
            var verP = stdin.readLineSync()!;
            if (newP == verP) {
              updatePassword(newP, matchinRows[0][1]);
              verify = false;
            } else {
              print('Kindly verify your password');
            }
          }
        }
        print('Welcome ${matchinRows[0][0]}');
        print('What task will you like to do?');
        var isLoggedIn = true;
        while (isLoggedIn) {
          print('Enter "1" to deposit for a customer');
          print('Enter "2" to transfer to another customer');
          print('Enter "3" to logout');
          String val = stdin.readLineSync()!;

          switch (val) {
            case "1":
              print('Enter the customer Account number');
              String acc = stdin.readLineSync()!;
              print('Enter the amount to deposit');
              String add = stdin.readLineSync()!;
              updatebal(acc, add);
              break;
            case '2':
              print('Enter the account number to transfer from');
              String acc = stdin.readLineSync()!;
              print('Enter the account number to transfer to');
              String friend = stdin.readLineSync()!;
              print('Enter the amount you will like to transfer');
              String add = stdin.readLineSync()!;
              transfer(friend, acc, add);
              break;
            case '3':
              isLoggedIn = false;
              isLogged = false;
              print('You have successfully logged out');
              break;
            default:
          }
        }
      } else {
        print('Try to log in again as your password or email is incorrect');
      }
    }
  }

  void updatePassword(String a, acc) {
    File staffFile = File('Staff.csv');
    var lines = staffFile.readAsLinesSync(encoding: utf8);
    var row = [];

    for (var line in lines) {
      if (line.contains(acc)) {
        var columns = line.split(',');
        columns[4] = 'false';
        columns[2] = a;
        row.add(columns);
      }
    }
    name = row[0][0];
    email = row[0][1];
    password = a;
    suspension = row[0][3];
    defaultP = 'false';
    int i = 0;
    for (var line in lines) {
      if (line.contains(acc)) {
        var columns = lines[i].split(',');
        columns[0] = name!;
        columns[1] = email!;
        columns[2] = password!;
        columns[3] = suspension.toString();
        columns[4] = defaultP;

        lines[i] = columns.join(',');
        staffFile.writeAsStringSync(lines.join('\n'));
      }
      i += 1;
    }
  }
}

class LoginDetails {
  String name;
  String email;
  String password;

  LoginDetails(
      {required this.name, required this.email, required this.password});
}

class CustomerLoginDetails {
  String name;
  String accountNumber;
  String password;
  String balance;

  CustomerLoginDetails(
      {required this.name,
      required this.accountNumber,
      required this.password,
      required this.balance});
}

class Admin {
  Staff staff = Staff();
  List<LoginDetails> staffLogins = [];
  List<CustomerLoginDetails> customerLogins = [];

  void printDetails() {
    File staffFile = File('Staff.csv');
    File customerFile = File('customers.csv');
    var lines = staffFile.readAsLinesSync(encoding: utf8);
    var lines2 = customerFile.readAsLinesSync(encoding: utf8);
    for (var line in lines) {
      var columns = line.split(',');

      var staffLogin = LoginDetails(
          name: columns[0], email: columns[1], password: columns[2]);

      addStaffLogin(staffLogin);
    }
    for (var line in lines2) {
      var columns = line.split(',');
      var customerLogin = CustomerLoginDetails(
          name: '${columns[0]},${columns[1]}',
          accountNumber: columns[7],
          password: columns[5],
          balance: columns[8]);

      addCustomerLogin(customerLogin);
    }

    // print(details);

    print('Welcome, Admin! Please view the logins below:');
    viewLogins();
  }

  void enterdetails() {
    bool login = true;
    var adminLogin = true;
    while (login) {
      print('Enter your admin details');
      print('Login Page');
      print('Enter your Username');
      String username = stdin.readLineSync()!;
      print('Enter your password');
      String pass = stdin.readLineSync()!;
      if (username == 'theghostbuster' && pass == '12345') {
        login = false;
        print('Welvome $username, what will you like to do today?');
        while (adminLogin) {
          print('Enter "1" to create a new staff login');
          print('Enter 2 to view customer and staff details');
          print('Enter "3" to suspend a staff');
          print('Enter "4" to reactivate a staff');
          print('Enter 5 to logout');
          String val = stdin.readLineSync()!;

          switch (val) {
            case "1":
              print('Welcome to staff signup page');
              print('Enter Staff name');
              String staffName = stdin.readLineSync()!;
              print('Enter staff email');
              String email = stdin.readLineSync()!;

              String passs = createStaff(staffName, email, staff.suspension);
              print('Staff created successfully');
              print('Staff password is $passs');
              break;
            case '2':
              print('List of Staff and customers details');
              printDetails();
              break;
            case '3':
              print(
                  'Enter the email address of the staff you will like to suspend');
              String sus = stdin.readLineSync()!;
              suspend(sus);
              break;
            case '4':
              print('Enter the staff email you want to reactivate');
              String sus = stdin.readLineSync()!;
              reactivate(sus);
              break;

            case '5':
              print('Goodbye');
              adminLogin = false;
              break;
            default:
          }
        }
      } else {
        print('You have inputed the wrong details');
        //adminLogin = false;
      }
    }

    // getAcc(accNum);
  }

  void reactivate(String email) {
    File staffCsv = File('Staff.csv');
    var lines = staffCsv.readAsLinesSync(encoding: utf8);
    var rows = [];
    for (var line in lines) {
      if (line.contains(email)) {
        var columns = line.split(',');
        if (columns[3] == 'false') {
          print('This staff was not suspended');
          return;
        }
        columns[3] = 'false';
        rows.add(columns);
      }
    }
    if (rows.isEmpty) {
      print('Staff does not exist');
      return;
    }
    staff.name = rows[0][0];
    staff.email = rows[0][1];
    staff.password = rows[0][2];
    staff.suspension = rows[0][3];
    int i = 0;
    for (var line in lines) {
      if (line.contains(email)) {
        var columns = lines[i].split(',');
        columns[0] = staff.name!;
        columns[1] = staff.email!;
        columns[2] = staff.password!;
        columns[3] = staff.suspension.toString();

        lines[i] = columns.join(',');
        staffCsv.writeAsStringSync(lines.join('\n'));
      }
      i += 1;
    }
    print('Staff successfuly Reactivated');
  }

  void suspend(String email) {
    File staffCsv = File('Staff.csv');
    var lines = staffCsv.readAsLinesSync(encoding: utf8);
    var rows = [];
    for (var line in lines) {
      if (line.contains(email)) {
        var columns = line.split(',');
        columns[3] = 'true';
        rows.add(columns);
      }
    }
    if (rows.isEmpty) {
      print('User does not exist');
      return;
    }
    staff.name = rows[0][0];
    staff.email = rows[0][1];
    staff.password = rows[0][2];
    staff.suspension = rows[0][3];
    int i = 0;
    for (var line in lines) {
      if (line.contains(email)) {
        var columns = lines[i].split(',');
        columns[0] = staff.name!;
        columns[1] = staff.email!;
        columns[2] = staff.password!;
        columns[3] = staff.suspension.toString();

        lines[i] = columns.join(',');
        staffCsv.writeAsStringSync(lines.join('\n'));
      }
      i += 1;
    }
    print('Staff successfuly Suspended');
  }

  String createStaff(n, e, s) {
    var randomPassword = Random();
    List defaultPassword = [];
    for (int i = 0; i < 4; i++) {
      int p = randomPassword.nextInt(9);
      defaultPassword.add(p);
    }
    String p = defaultPassword.join('');

    var filePath = 'Staff.csv';

    File staffCsv = File(filePath);
    if (staffCsv.existsSync()) {
      staffCsv.writeAsStringSync(
          '\n$n,$e,$p,${staff.suspension},${staff.defaultP}',
          mode: FileMode.append);
    } else {
      staffCsv.writeAsStringSync(
          'Name, Email, Password, Suspension_status, Default_Password',
          mode: FileMode.append);
      staffCsv.writeAsStringSync(
          '\n $n,$e,$p,${staff.suspension},${staff.defaultP}',
          mode: FileMode.append);
    }
    return p;
  }

  void addStaffLogin(LoginDetails login) {
    staffLogins.add(login);
  }

  void addCustomerLogin(CustomerLoginDetails newlogin) {
    customerLogins.add(newlogin);
  }

  void viewLogins() {
    print('Staff Logins:');
    for (var login in staffLogins) {
      print('Name: ${login.name}');
      print('Email: ${login.email}');
      print('Password: ${login.password}');
      print('');
    }

    print('Customer Logins:');
    for (var newlogin in customerLogins) {
      print('Name: ${newlogin.name}');
      print('Account Number: ${newlogin.accountNumber}');
      print('Password: ${newlogin.password}');
      print('balance: ${newlogin.balance}');
      print('');
    }
  }
}
