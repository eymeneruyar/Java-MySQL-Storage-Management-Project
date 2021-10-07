package Servlets;

import Entities.boxOfOrder;
import Utils.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "completedOrderServlet",value = "/completed-order")
public class CompletedOrderServlet extends HttpServlet {

    DBUtil util = new DBUtil();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int return_status = 0;

        int customer_id = Integer.parseInt(req.getParameter("customer_id"));
        List<boxOfOrder> ls = util.allBoxOfOrder(customer_id);

        if(ls.size() > 0){

            int p_id = ls.get(0).getP_id();
            String co_nameSurname = ls.get(0).getName_surname();
            String co_ticketNo = ls.get(0).getBo_ticketNo();
            int totalPrice = ls.stream().mapToInt(boxOfOrder::getBo_totalPrice).sum();
            int paymentStatus = 0;

            util.completedOrderInsert(customer_id,p_id,co_nameSurname,co_ticketNo,totalPrice,totalPrice,paymentStatus);
            return_status = 1;

            //Update Status BoxOfOrder
            util.updateStatusBoxOfOrder(customer_id);

            //Update stock of product
            ls.forEach(it->{
                util.updateQTYproduct(it.getP_id(),it.getBo_total());
            });


        }else{
            return_status = 0;
        }

        resp.setContentType("application/json");
        resp.getWriter().write("" + return_status);

    }

}
