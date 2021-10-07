package Servlets;

import Entities.View_CashBoxInCompletedOrder;
import Utils.DBUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "payInSearchServlet", value = "/payIn-search")
public class PayInSearchServlet extends HttpServlet {

    DBUtil util = new DBUtil();
    Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String s = req.getParameter("csearch");
        List<View_CashBoxInCompletedOrder> ls = util.payInSearch(s);

        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);
        System.out.println(stJson);

    }

}
