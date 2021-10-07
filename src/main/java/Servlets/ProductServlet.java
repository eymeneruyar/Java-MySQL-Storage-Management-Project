package Servlets;

import Entities.Product;
import Utils.DBUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "productServlet",value = {"/product-insert","/product-all","/product-delete"})
public class ProductServlet extends HttpServlet {

    DBUtil util = new DBUtil();

    //Product Insert Method
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String obj = req.getParameter("obj");
        int status = util.productInsert(obj);

        resp.setContentType("application/json");
        resp.getWriter().write("" + status);

    }

    //All Product List
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Gson gson = new Gson();
        List<Product> ls = util.allProduct();

        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);

    }

    //Delete Product
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int p_id = Integer.parseInt(req.getParameter("p_id"));
        int return_id = util.productDelete(p_id);

        resp.setContentType("application/json");
        resp.getWriter().write("" + return_id);

    }

}
