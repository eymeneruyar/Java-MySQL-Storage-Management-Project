package Servlets;

import Entities.View_boxOrder_cuPro;
import Entities.boxOfOrder;
import Utils.DBUtil;
import com.google.gson.Gson;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "newSaleServlet", value = {"/sale-add","/sale-list","/sale-delete"})
public class NewSaleServlet extends HttpServlet {

    Gson gson = new Gson();
    DBUtil util = new DBUtil();

    //New Sale Insert
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String obj = req.getParameter("obj");
        int status = util.newSaleInsert(obj);
        gson.toJson(obj);

        resp.setContentType("application/json");
        resp.getWriter().write("" + status);

    }

    //All Sales List
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int cu_id = Integer.parseInt(req.getParameter("cu_id"));
        List<View_boxOrder_cuPro> ls = util.viewBoCuPro(cu_id);

        //=======================================================================//
        List<View_boxOrder_cuPro> ls_view = util.viewBoCuPro();
        List<boxOfOrder> ls_box = util.allBoxOfOrder();
        int size = ls_view.size() - 1;
        int sizeBox = ls_box.size() - 1;

        if(ls_view.get(size).getBo_id() != ls_box.get(sizeBox).getBo_id()){
            int boxoforderStatus = util.boxOfOrderInsert(ls_view.get(size).getBo_id(),ls_view.get(size).getCu_id(),ls_view.get(size).getP_id(),ls_view.get(size).getBo_ticketNo(),
                    ls_view.get(size).getName_surname(),ls_view.get(size).getP_title(),ls_view.get(size).getP_salePrice(),ls_view.get(size).getBo_total(),
                    ls_view.get(size).getBo_totalPrice(),ls_view.get(size).getBo_status());
        }

        /*boxOfOrder bod = new boxOfOrder();
        ls_withoutCu_id.forEach(it->{
            int boxoforderStatus = util.boxOfOrderInsert(it.getBo_id(),it.getCu_id(),it.getP_id(),it.getBo_ticketNo(),it.getName_surname(),it.getP_title(),it.getP_salePrice(),it.getBo_total(),it.getBo_totalPrice(),it.getBo_status());
            System.out.println("boxoforderStatus: " + boxoforderStatus);
        });*/
        //=======================================================================//

        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);

    }

    //Sale Delete
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int bo_id = Integer.parseInt(req.getParameter("bo_id"));
        int return_id = util.saleDelete(bo_id);
        util.boxOfOrdersaleDelete(bo_id);

        resp.setContentType("application/json");
        resp.getWriter().write("" + return_id);

    }
}
