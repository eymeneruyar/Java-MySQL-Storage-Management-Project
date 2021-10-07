package Servlets;

import Entities.Product;
import Entities.ReportCOA;
import Entities.View_CheckOutActions;
import Utils.DBUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "checkOutActionsServlet",value = "/COAReport")
public class CheckOutActionsServlet extends HttpServlet {

    Gson gson = new Gson();
    DBUtil util = new DBUtil();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String obj = req.getParameter("obj");
        ReportCOA reportCOA = gson.fromJson(obj, ReportCOA.class);
        System.out.println(reportCOA.toString());
        String stJson = "";

        //Kasa value = -1 --- Giriş value = 1 --- Çıkış value = 2
        if(reportCOA.getCbIn_status() == 2 && reportCOA.getCu_id() == -1){ //Kasa Çıkış
            stJson = gson.toJson(util.allPaymentOutFilterDate(reportCOA.getCOA_startDate(),reportCOA.getCOA_endDate()));
            System.out.println("Kasa Çıkış");
        }else if(reportCOA.getCbIn_status() == 1 && reportCOA.getCu_id() != -1){ //Müşteri Giriş
            stJson = gson.toJson(util.viewCOATable(reportCOA.getCu_id(),reportCOA.getCOA_startDate(),reportCOA.getCOA_endDate()));
            System.out.println("Müşteri Giriş");
        }else{//Kasa Giriş
            stJson = gson.toJson(util.viewCOABoxInTable(reportCOA.getCOA_startDate(),reportCOA.getCOA_endDate()));
            System.out.println("Kasa Giriş");
        }

        //ls.forEach(it-> System.out.println("deneme: " + it.toString()));

        resp.setContentType("application/json");
        resp.getWriter().write(stJson);

    }

}
