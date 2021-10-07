package Servlets;

import Entities.View_boxOrder_cuPro;
import Entities.boxOfOrder;
import Utils.DBUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "newSaleServletPriceBox",value = "/price-box")
public class NewSaleServletPriceBox extends HttpServlet {

    Gson gson = new Gson();
    DBUtil util = new DBUtil();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int cu_id = Integer.parseInt(req.getParameter("cu_id"));
        List<View_boxOrder_cuPro> ls = util.viewBoCuPro(cu_id);

        int totalPriceOfBox = ls.stream().mapToInt(View_boxOrder_cuPro::getBo_totalPrice).sum();

        resp.setContentType("application/json");
        resp.getWriter().write("" + totalPriceOfBox);


    }

}
