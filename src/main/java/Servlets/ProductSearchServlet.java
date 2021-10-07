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

@WebServlet(name = "productSearchServlet", value = "/product-search")
public class ProductSearchServlet extends HttpServlet {

    DBUtil util = new DBUtil();
    Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String s = req.getParameter("psearch");
        List<Product> ls = util.productSearch(s);
        System.out.println("keyboard val: " + s);

        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);
        System.out.println("stjson:"+ stJson);

    }

}
