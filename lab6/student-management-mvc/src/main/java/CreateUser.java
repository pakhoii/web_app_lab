import com.student.dao.UserDAO;
import com.student.model.User;

public class CreateUser {
    public static void main(String[] args) {
//        User newUser = new User(
//            "khoi",
//                "123",
//                "Pham Anh Khoi",
//                "admin"
//        );

        UserDAO userDAO = new UserDAO();
//        userDAO.createUser(newUser);

        User newUser = new User(
                "binh",
                "123",
                "Nguyen The Binh",
                "user"
        );

        userDAO.createUser(newUser);
    }
}