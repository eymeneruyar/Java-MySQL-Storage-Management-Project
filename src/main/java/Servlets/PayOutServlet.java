package Servlets;

import Entities.CashBoxOut;
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

@WebServlet(name = "payOutServlet",value = {"/payOut-insert","/payOut-allPayment","/payOut-deletePayment"})
public class PayOutServlet extends HttpServlet {

    Gson gson = new Gson();
    DBUtil util = new DBUtil();

    //Insert Payment Out
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String obj = req.getParameter("obj");
        int status = util.paymentOutInsert(obj);

        resp.setContentType("application/json");
        resp.getWriter().write( "" +status );

    }

    //All Payment Out
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<CashBoxOut> ls = util.allPaymentOut();
        String stJson = gson.toJson(ls);

        resp.setContentType("application/json");
        resp.getWriter().write(stJson);

    }

    //Delete Payment Out
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int cbOut_id = Integer.parseInt(req.getParameter("cbOut_id"));
        int return_id = util.paymentOutDelete(cbOut_id);

        resp.setContentType("application/json");
        resp.getWriter().write("" + return_id);

    }
}
