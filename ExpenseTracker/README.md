# Expense Tracker – Eclipse / JDK 26 / Tomcat 9

This is a small web version of the Personal Expense Tracker described in the supplied PDF.
The PDF explains the features and development structure; it does not contain complete
ready-to-run source code. This project implements a practical starter version of those ideas.

## Features included
- Welcome page: `start.html`
- User registration and login
- Add income and expense transactions
- View saved transactions
- Dashboard totals: income, expenses and current balance
- MySQL database storage
- Simple category and date fields

## Software
- JDK 26 installed and selected in Eclipse
- Eclipse IDE for Enterprise Java and Web Developers
- Apache Tomcat 9
- MySQL Server 8.x
- Maven support in Eclipse

## Important compatibility note
Tomcat 9 uses the older `javax.servlet` API. This project intentionally uses
`javax.servlet` imports and compiles the application with Java 9 language/API
compatibility so that the application remains compatible with Tomcat 9.
You can run Eclipse itself with JDK 26. If your installed Tomcat 9 build or
third-party libraries show a runtime issue on JDK 26, use a supported JDK for
the Tomcat server or upgrade the server to a newer compatible Tomcat version.

## 1. Create the database
1. Open MySQL Workbench or MySQL Command Line Client.
2. Run all commands from `database/expense_tracker.sql`.
3. The database name is `expense_tracker`.

## 2. Set your database password
Open `src/main/java/com/expensetracker/database/DBConnection.java`.
Change `DB_PASSWORD` to the password you use for your local MySQL account.
The default username is `root`.

## 3. Import into Eclipse
1. Extract the ZIP.
2. Open Eclipse.
3. Select **File -> Import -> Maven -> Existing Maven Projects**.
4. Browse to the extracted `ExpenseTracker` folder.
5. Select `pom.xml`, then click **Finish**.
6. Right-click the project -> **Maven -> Update Project**.
7. Set the project JRE to JDK 26 in **Properties -> Java Build Path**.
8. Add Apache Tomcat 9 in **Window -> Show View -> Servers -> New -> Server**.
9. Add this project to the Tomcat server.

## 4. Run
Right-click the project -> **Run As -> Run on Server**.
Open:

`http://localhost:8080/ExpenseTracker/start.html`

The welcome page's buttons lead to the registration and login pages.

## Project structure
- `start.html` – custom welcome/landing page
- `login.jsp`, `register.jsp` – login and registration forms
- `dashboard.jsp` – totals and transaction list
- `add-transaction.jsp` – add income or expense
- `src/main/java/.../database` – JDBC connection
- `src/main/java/.../dao` – SQL queries
- `src/main/java/.../servlet` – request handling
- `database` – SQL setup

## Notes
- This is a learning project, not a production financial application.
- Use a strong database password and do not publish your credentials.
- Passwords are stored as salted PBKDF2 hashes, not plain text.
- The project has not been tested on your individual computer; local MySQL,
  Eclipse and Tomcat configuration may need adjustment.
