package Servlets;

import Entities.CashBoxIn;
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

@WebServlet(name = "payInServlet", value = {"/payIn-insert","/payIn-allPayment","/payIn-deletePayment"})
public class PayInServlet extends HttpServlet {

    Gson gson = new Gson();
    DBUtil util = new DBUtil();

    //Add payment
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String obj = req.getParameter("obj");
        CashBoxIn cbIn = gson.fromJson(obj, CashBoxIn.class);
        List<CashBoxIn> ls = util.allPayment();
        //int status = util.paymentInsert(obj);
        int status = 0;

        for(CashBoxIn it : ls){

            if(it.getCbIn_ticketNo().equals(cbIn.getCbIn_ticketNo())){
                util.updateCashBoxPayAmount(cbIn.getCbIn_payAmount(), cbIn.getCbIn_ticketNo());
                status = 1;
                System.out.println("Update Section Opened");
            }else{
                status = util.paymentInsert(obj);
                System.out.println("Insert Section Opened");
                break;
            }

        }

        //Update CompleteOrder Price
        util.updateCOprice(cbIn.getCbIn_ticketNo(),cbIn.getCbIn_payAmount());
        //Update CompleteOrder Price

        resp.setContentType("application/json");
        resp.getWriter().write( "" +status );

    }

    //All payments
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<View_CashBoxInCompletedOrder> ls = util.viewCbInCO();
        String stJson = gson.toJson(ls);

        resp.setContentType("application/json");
        resp.getWriter().write(stJson);

    }

    //Delete Payment
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int cbIn_id = Integer.parseInt(req.getParameter("cbIn_id"));
        int return_id = util.paymentDelete(cbIn_id);

        resp.setContentType("application/json");
        resp.getWriter().write("" + return_id);

    }
}
