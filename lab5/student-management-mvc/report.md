# Lab 5 - SERVLET & MVC PATTERN

## PART A: IN-CLASS EXERCISES
### EXERCISE 1: PROJECT SETUP & MODEL LAYER
#### Task 1.1: Create Project Structure
Steps:
- Create new Web Application project: StudentManagementMVC
- Create Java packages: model, dao, controller
- Create views folder inside Web Pages
- Add MySQL Connector/J library

Result:
![Project Structure](images/image.png)

#### Task 1.2: Create Student JavaBean
Defining the constructor, setter getter methods for class `Student`
```java
package com.student.model;

import java.sql.Timestamp;

public class Student {
    private int id;
    private String studentCode;
    private String fullName;
    private String email;
    private String major;
    private Timestamp createdAt;

    // No-arg constructor (required for JavaBean)
    public Student() {
    }

    // Constructor for creating new student (without ID)
    public Student(String studentCode, String fullName, String email, String major) {
        this.studentCode = studentCode;
        this.fullName = fullName;
        this.email = email;
        this.major = major;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudentCode() {
        return studentCode;
    }

    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", studentCode='" + studentCode + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", major='" + major + '\'' +
                '}';
    }
}
```

Here is the **shorter, item-list version** — each method ≈ **30–40 words**, very concise and clean:

#### Task 1.3: Create `StudentDAO`

**1. Database Configuration**

```java
private static final String DB_URL = "...";
private static final String DB_USER = "...";
private static final String DB_PASSWORD = "...";
```

* Stores database connection details.
* Centralizes configuration for easy maintenance.
* Used by all DAO methods to open SQL connections.

**2. getConnection()**

```java
private Connection getConnection() throws SQLException { ... }
```

* Loads JDBC driver and opens a MySQL connection.
* Wraps driver errors into `SQLException`.
* Ensures all DAO operations reuse one consistent connection method.

**3. getAllStudents()**

```java
public List<Student> getAllStudents() { ... }
```

* Retrieves all records from `students` table.
* Uses try-with-resources to auto-close JDBC resources.
* Returns a `List<Student>` for controllers to display in the view.

**DAO → Controller → View Relationship**

* **DAO:** Talks to the database (CRUD only).
* **Controller:** Calls DAO methods, handles logic, sends data to views.
* **View:** Shows lists, forms, and details using controller-provided data.

---
Here you go — **EXERCISE 2** written exactly in the **same format** as your EXERCISE 1 section:
✔ Short
✔ Item-list
✔ Method-by-method
✔ Same markdown structure

---

### **EXERCISE 2: CONTROLLER LAYER**
#### **Task 2.1: Create Basic Servlet (`StudentController`)**

**1. init()**

```java
@Override
public void init() {
    studentDAO = new StudentDAO();
}
```

* Initializes the DAO once when the servlet starts.
* Ensures all future requests can access the database layer.
* Prevents repeated DAO creation during request handling.

**2. doGet()**

```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException { ... }
```

* Reads the `action` parameter to determine what the user wants.
* Defaults to `"list"` when no action is provided.
* Routes requests to listing, creating, editing, or deleting student operations.

**3. listStudents()**

```java
private void listStudents(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException { ... }
```

* Retrieves all students from the DAO.
* Stores the data in a request attribute for the JSP to access.
* Forwards the request to `student-list.jsp` to render the table.

#### **Task 2.2: Add CRUD Methods**

**4. showNewForm()**

```java
private void showNewForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException { ... }
```

* Displays the form for adding a new student.
* No DAO call needed because it's an empty form.
* Forwards to `student-form.jsp`.

**5. showEditForm()**

```java
private void showEditForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException { ... }
```

* Reads the student ID from the request.
* Loads the corresponding student using the DAO.
* Forwards to the same form JSP with data pre-filled.

**6. doPost()**

```java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException { ... }
```

* Handles all POST form submissions.
* Routes to `insert` or `update` actions based on the action parameter.
* Ensures GET is only for page display, POST is for modification.

**7. insertStudent()**

```java
private void insertStudent(HttpServletRequest request, HttpServletResponse response)
        throws IOException { ... }
```

* Reads form values and creates a new Student.
* Calls DAO to insert into the database.
* Redirects to the student list with a success or error message.

**8. updateStudent()**

```java
private void updateStudent(HttpServletRequest request, HttpServletResponse response)
        throws IOException { ... }
```

* Collects updated data into a Student object.
* Sends the data to DAO for modification.
* Redirects with a notification message.

**9. deleteStudent()**

```java
private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
        throws IOException { ... }
```

* Deletes a student using its ID.
* Calls DAO → removes the record from the database.
* Redirects back to the list view with a success/error result.

**Controller → DAO → View Relationship**

* **Controller:** Receives HTTP requests, decides what to do, and chooses which JSP to show.
* **DAO:** Executes database operations requested by the controller.
* **View (JSP):** Displays data provided by the controller.

---
### EXERCISE 3: VIEW LAYER WITH JSTL
#### Task 3.1: Create Student List View 
**Code:**
```html
<body>
<div class="container">
    <h1>📚 Student Management System</h1>
    <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>

    <!-- Success Message -->
    <c:if test="${not empty param.message}">
        <div class="message success">
            ✅ ${param.message}
        </div>
    </c:if>

    <!-- Error Message -->
    <c:if test="${not empty param.error}">
        <div class="message error">
            ❌ ${param.error}
        </div>alt text
    </c:if>

    <!-- Add New Student Button -->
    <div style="margin-bottom: 20px;">
        <a href="student?action=new" class="btn btn-primary">
            ➕ Add New Student
        </a>
    </div>

    <!-- Student Table -->
    <c:choose>
        <c:when test="${not empty students}">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Code</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Major</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="student" items="${students}">
                    <tr>
                        <td>${student.id}</td>
                        <td><strong>${student.studentCode}</strong></td>
                        <td>${student.fullName}</td>
                        <td>${student.email}</td>
                        <td>${student.major}</td>
                        <td>
                            <div class="actions">
                                <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">
                                    ✏️ Edit
                                </a>
                                <a href="student?action=delete&id=${student.id}"
                                   class="btn btn-danger"
                                   onclick="return confirm('Are you sure you want to delete this student?')">
                                    🗑️ Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">📭</div>
                <h3>No students found</h3>
                <p>Start by adding a new student</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
```
**Result:**
![Student List Page](images/image-1.png)

#### Task 3.2: Create Student Form View
**Code:**
```html
<body>
<div class="container">
    <h1>
        <c:choose>
            <c:when test="${student != null}">
                ✏️ Edit Student
            </c:when>
            <c:otherwise>
                ➕ Add New Student
            </c:otherwise>
        </c:choose>
    </h1>

    <form action="student" method="POST">
        <!-- Hidden field for action -->
        <input type="hidden" name="action"
               value="${student != null ? 'update' : 'insert'}">

        <!-- Hidden field for ID (only for update) -->
        <c:if test="${student != null}">
            <input type="hidden" name="id" value="${student.id}">
        </c:if>

        <!-- Student Code -->
        <div class="form-group">
            <label for="studentCode">
                Student Code <span class="required">*</span>
            </label>
            <input type="text"
                   id="studentCode"
                   name="studentCode"
                   value="${student.studentCode}"
            ${student != null ? 'readonly' : 'required'}
                   placeholder="e.g., SV001, IT123">
            <p class="info-text">Format: 2 letters + 3+ digits</p>
        </div>

        <!-- Full Name -->
        <div class="form-group">
            <label for="fullName">
                Full Name <span class="required">*</span>
            </label>
            <input type="text"
                   id="fullName"
                   name="fullName"
                   value="${student.fullName}"
                   required
                   placeholder="Enter full name">
        </div>

        <!-- Email -->
        <div class="form-group">
            <label for="email">
                Email <span class="required">*</span>
            </label>
            <input type="email"
                   id="email"
                   name="email"
                   value="${student.email}"
                   required
                   placeholder="student@example.com">
        </div>

        <!-- Major -->
        <div class="form-group">
            <label for="major">
                Major <span class="required">*</span>
            </label>
            <select id="major" name="major" required>
                <option value="">-- Select Major --</option>
                <option value="Computer Science"
                ${student.major == 'Computer Science' ? 'selected' : ''}>
                    Computer Science
                </option>
                <option value="Information Technology"
                ${student.major == 'Information Technology' ? 'selected' : ''}>
                    Information Technology
                </option>
                <option value="Software Engineering"
                ${student.major == 'Software Engineering' ? 'selected' : ''}>
                    Software Engineering
                </option>
                <option value="Business Administration"
                ${student.major == 'Business Administration' ? 'selected' : ''}>
                    Business Administration
                </option>
            </select>
        </div>

        <!-- Buttons -->
        <div class="button-group">
            <button type="submit" class="btn btn-primary">
                <c:choose>
                    <c:when test="${student != null}">
                        💾 Update Student
                    </c:when>
                    <c:otherwise>
                        ➕ Add Student
                    </c:otherwise>
                </c:choose>
            </button>
            <a href="student?action=list" class="btn btn-secondary">
                ❌ Cancel
            </a>
        </div>
    </form>
</div>
</body>
```
**Result:**
![Add Student Form Page](images/image-2.png)

---
### EXERCISE 4: COMPLETE CRUD OPERATIONS
#### Task 4.1: Complete DAO Methods 
**1. getStudentById()**

```java
public Student getStudentById(int id) { ... }
```

* Fetches one student by ID using a prepared statement.
* Maps the result to a `Student` object.
* Used by controllers for detail pages or update forms.

**2. addStudent()**

```java
public boolean addStudent(Student student) { ... }
```

* Inserts a new student into the database.
* Binds form values safely using prepared statements.
* Returns true/false so the controller knows whether creation succeeded.

**3. updateStudent()**

```java
public boolean updateStudent(Student student) { ... }
```

* Updates an existing student’s fields based on ID.
* Called after submitting an edit form.
* Controller uses the boolean result to redirect or show an error.

**4. deleteStudent()**

```java
public boolean deleteStudent(int id) { ... }
```
* Deletes a student by ID.
* Used when user clicks a delete button.
* Returns success status for controller to update the view.

#### Task 4.2: Integration Testing

**Test Sequence:**
- List: Navigate to /student - should see existing students
    ![Navigate to `/student`](images/image-3.png)
- Add: Click "Add New Student"
  - Fill form with test data
      ![Filling the Form](images/image-4.png)
  - Submit
  - Should redirect to list with success message
      ![Added Successfully](images/image-5.png)
- Edit: Click "Edit" on test student
  - Form should pre-fill
        ![Pre-filled Form](images/image-6.png)
  - Modify data
        ![Modifying Data](images/image-7.png)
  - Submit
  - Should redirect with update message
        ![Update Successfully](images/image-8.png)
- Delete: Click "Delete" on test student
  - Should confirm
        ![Confirm Messages](images/image-9.png)
  - Should redirect with delete message
        ![Delete Successfully](images/image-10.png)
- Empty State: Delete all students
  - Should show "No students found" message
        ![Empty State](images/image-11.png)

