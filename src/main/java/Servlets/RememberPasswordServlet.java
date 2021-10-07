package Servlets;

import Entities.Customer;
import Entities.User;
import Utils.DBUtil;
import Utils.HibernateUtil;
import com.google.gson.Gson;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "rememberPasswordServlet",value = "/remember-password-servlet")
public class RememberPasswordServlet extends HttpServlet {

    DBUtil util = new DBUtil();
    Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String us_email = req.getParameter("userEmail");
        System.out.println(us_email);

        User user = util.rememberPassword(us_email);
        String userPassword = "";

        if(user != null){
            userPassword = user.getUs_password();
        }else{
            //Null pointer exception hatasını önlemek için string tipinde 0 yolladım.
            //Javascript tarafında da kontrolümü ona göre gerçekleştirdim.
            userPassword = "0";
        }

        resp.setContentType("application/json");
        resp.getWriter().write(userPassword);

    }

}
