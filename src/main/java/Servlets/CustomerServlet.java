package Servlets;

import Entities.Customer;
import Entities.Product;
import Utils.DBUtil;
import Utils.HibernateUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "customerServlet",value = {"/customer-post","/customer-delete","/customer-get"})
public class CustomerServlet extends HttpServlet {

    DBUtil util = new DBUtil();

    //Customer Insert
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String obj = req.getParameter("obj");
        int status = util.customerInset(obj);

        resp.setContentType("application/json");
        resp.getWriter().write( "" +status );

    }

    //All Customer Show
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Gson gson = new Gson();
        List<Customer> ls = util.allCustomer();

        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);

    }

    //Customer Delete
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int cu_id = Integer.parseInt(req.getParameter("cu_id"));
        int return_id = util.customerDelete(cu_id);

        resp.setContentType("application/json");
        resp.getWriter().write("" + return_id);

    }

}
