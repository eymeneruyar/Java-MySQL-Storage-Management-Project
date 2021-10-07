package Servlets;

import Entities.CashBoxOut;
import Entities.Customer;
import Utils.DBUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "payOutSearchServlet", value = "/payOut-search")
public class PayOutSearchServlet extends HttpServlet {

    DBUtil util = new DBUtil();
    Gson gson = new Gson();

    //PayOut Search Servlet
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String s = req.getParameter("csearch");
        List<CashBoxOut> ls = util.payOutSearch(s);

        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);

    }

}
