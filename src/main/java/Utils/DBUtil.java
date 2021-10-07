package Utils;

import Entities.*;
import com.google.gson.Gson;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DBUtil {

    SessionFactory sf = HibernateUtil.getSessionFactory();
    Transaction tr = null;

    //=========================================== Login Section - Start ===========================================//
    public boolean login(String us_email, String us_password, String remember, HttpServletRequest req, HttpServletResponse resp) {

        boolean status = false;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "from User where us_email = :us_email and us_password = :us_password";
            User user = (User) sesi
                    .createQuery(sql)
                    .setParameter("us_email", us_email)
                    .setParameter("us_password", us_password)
                    .uniqueResult();

            if (user != null && user.getUs_email().equals(us_email) && user.getUs_password().equals(us_password)) {

                //Session Create
                int us_id = user.getUs_id();
                String us_name = user.getUs_name();
                String us_surname = user.getUs_surname();
                req.getSession().setAttribute("us_id", us_id);
                req.getSession().setAttribute("us_name", us_name);
                req.getSession().setAttribute("us_surname", us_surname);

                //Cookie Create
                if (remember != null && remember.equals("on")) {
                    us_name = us_name.replaceAll(" ", "_");
                    String val = us_id + "_" + us_name + "_" + us_surname;
                    Cookie cookie = new Cookie("user", val);
                    cookie.setMaxAge(60 * 60);
                    resp.addCookie(cookie);
                }

                status = true;

            }

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Login Error: " + e);
        } finally {
            sesi.close();
        }
        return status;
    }
    //=========================================== Login Section - End ===========================================//

    //=========================================== Remember Password with E-Mail Section - Start ===========================================//
    public User rememberPassword(String us_email){

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();
        User user = new User();

        try {

            String sql = "from User where us_email = :us_email";
            user = (User) sesi
                    .createQuery(sql)
                    .setParameter("us_email",us_email)
                    .uniqueResult();

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Remember Password Error: " + e);
        } finally {
            sesi.close();
        }
        return user;
    }
    //=========================================== Remember Password with E-Mail Section - End ===========================================//

    //=========================================== Customer Section - Start ===========================================//

    //Customer Insert
    public int customerInset(String obj) {

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            Gson gson = new Gson();
            Customer customer = gson.fromJson(obj, Customer.class);
            Date date = new Date();
            customer.setCu_date(date);

            sesi.saveOrUpdate(customer);
            tr.commit();
            status = 1;

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Save or Update Customer Error : " + e);
        } finally {
            sesi.close();
        }

        return status;

    }

    //All Customer
    public List<Customer> allCustomer(){

        List<Customer> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "from Customer";
            ls = sesi.createQuery(sql).getResultList();
            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Customer Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Customer Delete
    public int customerDelete(int cu_id){

        int return_id = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            Customer customer = sesi.load(Customer.class,cu_id);
            sesi.delete(customer);
            tr.commit();
            return_id = customer.getCu_id();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Customer Delete Error: " + e);
        } finally {
            sesi.close();
        }

        return return_id;

    }

    //Customer Search
    public List<Customer> customerSearch(String s){

        Session sesi = sf.openSession();
        List<Customer> ls = new ArrayList();

        try {

            Query query = sesi
                    .createSQLQuery("CALL ProcCustomerSearch(?)")
                    .addEntity(Customer.class)
                    .setParameter(1,s);
            ls = query.getResultList();

        } catch (Exception e) {
            System.err.println("Customer Search Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //=========================================== Customer Section - End ===========================================//

    //=========================================== Product Section - Start ===========================================//

    //Product Insert
    public int productInsert(String obj){

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {
            Gson gson = new Gson();
            Product product = gson.fromJson(obj, Product.class);
            sesi.saveOrUpdate(product);
            tr.commit();
            status = 1;
        }catch ( Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Save or Update Product Error : " + e);
        }finally {
            sesi.close();
        }

        return status;

    }

    //All Product List
    public List<Product> allProduct(){

        List<Product> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "from Product";
            ls = sesi.createQuery(sql).getResultList();
            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Product Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Product Delete
    public int productDelete(int p_id){

        int return_id = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            Product product = sesi.load(Product.class,p_id);
            sesi.delete(product);
            tr.commit();
            return_id = product.getP_id();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Product Delete Error: " + e);
        } finally {
            sesi.close();
        }

        return return_id;

    }

    //Product Search
    public List<Product> productSearch(String s){

        Session sesi = sf.openSession();
        List<Product> ls = new ArrayList();

        try {

            Query query = sesi
                    .createSQLQuery("CALL ProcProductSearch(?)")
                    .addEntity(Product.class)
                    .setParameter(1,s);
            ls = query.getResultList();

        } catch (Exception e) {
            System.err.println("Product Search Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Update Quantity of Product Stock
    public int updateQTYproduct(int p_id,int qty){

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            sesi.createSQLQuery("CALL ProcUpdateProductStock (?,?)")
                    .setParameter(1,p_id)
                    .setParameter(2,qty)
                    .executeUpdate();

            tr.commit();
            status = 1;

        } catch (Exception e) {
            System.err.println("Update Stock of Product Quantity Error: " + e);
        } finally {
            sesi.close();
        }
        return status;
    }

    //Last 5 Product in Stock
    public List<Product> last5Products(){

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();
        List<Product> ls = new ArrayList<>();

        try {

            String sql = "from Product where p_quantity <= 5";
            ls = sesi.createQuery(sql).getResultList();

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Last 5 Product in Stock Error: " + e);
        } finally {
            sesi.close();
        }
        return ls;
    }

    //=========================================== Product Section - End ===========================================//

    //=========================================== New Sale Section - Start ===========================================//

    //New Sale Insert
    public int newSaleInsert(String obj){

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {
            Gson gson = new Gson();
            BoxOrder boxOrder = gson.fromJson(obj, BoxOrder.class);

            Date date = new Date();
            boxOrder.setBo_date(new SimpleDateFormat("dd-MM-yyyy").format(date));

            boxOrder.setBo_totalPrice(0);
            boxOrder.setBo_status(0);

            int bo_id = (int) sesi.save(boxOrder);
            int cu_id = boxOrder.getBo_customer();

            //boxOrder.setBo_id(id);

            String sql = "insert into customer_boxorder values (?,?)";
            status = sesi
                    .createNativeQuery(sql)
                    .setParameter(1,cu_id)
                    .setParameter(2,bo_id)
                    .executeUpdate();

            tr.commit();
            status = 1;
        }catch ( Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("New Sale Insert Error : " + e);
        }finally {
            sesi.close();
        }

        return status;

    }

    //Sale Delete
    public int saleDelete(int bo_id){

        int return_id = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            BoxOrder boxOrder = sesi.load(BoxOrder.class,bo_id);
            sesi.delete(boxOrder);
            tr.commit();
            return_id = boxOrder.getBo_id();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Sale Delete Error: " + e);
        } finally {
            sesi.close();
        }

        return return_id;

    }

    //=========================================== New Sale Section - End ===========================================//

    //=========================================== Completed Order Section - Start ===========================================//

    //Completed Order Insert
    public int completedOrderInsert(int c_id,int p_id,String co_nameSurname, String co_ticketNo, int totalPrice,int co_avail,int paymentStatus){

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {
            CompletedOrder co = new CompletedOrder();
            Date date = new Date();
            co.setC_id(c_id);
            co.setP_id(p_id);
            co.setCo_nameSurname(co_nameSurname);
            co.setCo_ticketNo(co_ticketNo);
            co.setTotalPrice(totalPrice);
            co.setCo_amountPaid(0);
            co.setCo_avail(co_avail);
            co.setPaymentStatus(paymentStatus);
            co.setCo_date(new SimpleDateFormat("yyyy-MM-dd").format(date));
            int co_id = (int) sesi.save(co);
            co.setCo_id(co_id);
            tr.commit();
            status = 1;
        }catch ( Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Completed Order Insert Error : " + e);
        }finally {
            sesi.close();
        }

        return status;

    }

    //Completed Order without cu_id Table Member
    public List<CompletedOrder> allcompletedOrder(){

        List<CompletedOrder> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "select * from CompletedOrder";
            Query query = sesi
                    .createSQLQuery(sql)
                    .addEntity(CompletedOrder.class);

            ls = query.getResultList();

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Completed Order without cu_id Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Update paymentStatus, amountPaid, avail
    public int updateCOprice(String co_ticketNo,int payQTY){

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            sesi.createSQLQuery("CALL ProcUpdateCompletedOrderPrice (?,?)")
                    .setParameter(1,co_ticketNo)
                    .setParameter(2,payQTY)
                    .executeUpdate();

            status = 1;

        } catch (Exception e) {
            System.err.println("Update CompletedOrder PaymentStatus, AmountPaid, Avail Error: " + e);
        } finally {
            sesi.close();
        }
        return status;
    }

    //=========================================== Completed Order Section - End ===========================================//

    //=========================================== Box of Order Section - Start ===========================================//

    //Box of Order Insert
    public int boxOfOrderInsert(int bo_id, int cu_id, int p_id, String bo_ticketNo,String name_surname, String p_title,int p_salePrice,int bo_total,int bo_totalPrice,int bo_status) {

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            boxOfOrder bod = new boxOfOrder();
            bod.setBo_id(bo_id);
            bod.setCu_id(cu_id);
            bod.setP_id(p_id);
            bod.setName_surname(name_surname);
            bod.setBo_ticketNo(bo_ticketNo);
            bod.setP_title(p_title);
            bod.setP_salePrice(p_salePrice);
            bod.setBo_total(bo_total);
            bod.setBo_totalPrice(bo_totalPrice);
            bod.setBo_status(bo_status);

            sesi.saveOrUpdate(bod);

            tr.commit();
            status = 1;

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Box Of Order Insert Error : " + e);
        } finally {
            sesi.close();
        }

        return status;

    }

    //BoxOfOrder Sale Delete
    public int boxOfOrdersaleDelete(int bo_id){

        int return_id = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            sesi.createSQLQuery("CALL ProcBoxOfOrderDelete(?)").setParameter(1,bo_id).executeUpdate();

            tr.commit();
            return_id = 1;

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("BoxOfOrder Sale Delete Error: " + e);
        } finally {
            sesi.close();
        }

        return return_id;

    }

    //All Box of Order Table Member
    public List<boxOfOrder> allBoxOfOrder(int cu_id){

        List<boxOfOrder> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "select * from boxoforder as bod where bod.cu_id = :cu_id and bod.bo_status = 0";
            Query query = sesi
                    .createSQLQuery(sql)
                    .setParameter("cu_id",cu_id)
                    .addEntity(boxOfOrder.class);

            ls = query.getResultList();

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Box Of Order Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //All Box of Order Table Member
    public List<boxOfOrder> allBoxOfOrder(){

        List<boxOfOrder> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "select * from boxoforder as bod ";
            Query query = sesi
                    .createSQLQuery(sql)
                    .addEntity(boxOfOrder.class);

            ls = query.getResultList();

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Box Of Order Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Update BoxofOrder Status
    public int updateStatusBoxOfOrder(int cu_id){

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            sesi.createSQLQuery("CALL ProcUpdateStatusBOD (?)").setParameter(1,cu_id).executeUpdate();

            status = 1;

        } catch (Exception e) {
            System.err.println("Update Status Box of Order Error: " + e);
        } finally {
            sesi.close();
        }
        return status;
    }

    //=========================================== Box of Order Section - End ===========================================//

    //=========================================== Cash Box Input Section - Start ===========================================//

    // Insert Payment
    public int paymentInsert(String obj) {

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            Gson gson = new Gson();
            CashBoxIn cbIn = gson.fromJson(obj, CashBoxIn.class);
            Date date = new Date();
            cbIn.setCbIn_date(new SimpleDateFormat("yyyy-MM-dd").format(date));
            cbIn.setCbIn_status(1);
            //cbIn.setCbIn_payAmount(0); // PayInServler "Add Payment" kısmında alt satırda kendim güncelliyorum. Bu yüzden 0 değeri set ettim.

            sesi.saveOrUpdate(cbIn);
            tr.commit();
            status = 1;

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Save or Update Payment Error : " + e);
        } finally {
            sesi.close();
        }

        return status;

    }

    //All Payments
    public List<CashBoxIn> allPayment(){

        List<CashBoxIn> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "select * from CashBoxIn";
            ls = sesi.createSQLQuery(sql).addEntity(CashBoxIn.class).getResultList();
            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Payments Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Delete Payment
    public int paymentDelete(int cbIn_id){

        int return_id = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            CashBoxIn cbIn = sesi.load(CashBoxIn.class,cbIn_id);
            sesi.delete(cbIn);
            tr.commit();
            return_id = cbIn.getCbIn_id();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Payment Delete Error: " + e);
        } finally {
            sesi.close();
        }

        return return_id;

    }

    //PayIn Search
    public List<View_CashBoxInCompletedOrder> payInSearch(String s){

        Session sesi = sf.openSession();
        List<View_CashBoxInCompletedOrder> ls = new ArrayList();

        try {

            Query query = sesi
                    .createSQLQuery("CALL ProcPayInSearch(?)")
                    .addEntity(View_CashBoxInCompletedOrder.class)
                    .setParameter(1,s);
            ls = query.getResultList();

        } catch (Exception e) {
            System.err.println("PayIn Search Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Filter of payment with Date
    public List<CashBoxIn> allPaymentInFilterDate(String date){

        List<CashBoxIn> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "from CashBoxIn where cbIn_date = :date";
            ls = sesi.createQuery(sql).setParameter("date",date).getResultList();
            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Payment In Filter Date Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Update Pay Amount Value
    public int updateCashBoxPayAmount(int paid ,String co_ticketNo){

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            sesi.createSQLQuery("CALL ProcUpdateCashBoxInPriceAmount (?,?)")
                    .setParameter(1,paid)
                    .setParameter(2,co_ticketNo)
                    .executeUpdate();

            status = 1;

        } catch (Exception e) {
            System.err.println("Update Pay Amount Value in CashBoxIn Table Error: " + e);
        } finally {
            sesi.close();
        }
        return status;
    }

    //=========================================== Cash Box Input Section - End ===========================================//

    //=========================================== Cash Box Output Section - Start ===========================================//

    // Insert Payment Out
    public int paymentOutInsert(String obj) {

        int status = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            Gson gson = new Gson();
            CashBoxOut cbOut = gson.fromJson(obj, CashBoxOut.class);
            Date date = new Date();
            cbOut.setCbOut_date(new SimpleDateFormat("yyyy-MM-dd").format(date));
            cbOut.setCbOut_status(2);

            sesi.saveOrUpdate(cbOut);
            tr.commit();
            status = 1;

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Save or Update Payment Out Error : " + e);
        } finally {
            sesi.close();
        }

        return status;

    }

    //All Payments Out
    public List<CashBoxOut> allPaymentOut(){

        List<CashBoxOut> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "from CashBoxOut";
            ls = sesi.createQuery(sql).getResultList();
            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Payments Out Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Payment Out Delete
    public int paymentOutDelete(int cbOut_id){

        int return_id = 0;

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            CashBoxOut cbOut = sesi.load(CashBoxOut.class,cbOut_id);
            sesi.delete(cbOut);
            tr.commit();
            return_id = cbOut.getCbOut_id();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("Payment Out Delete Error: " + e);
        } finally {
            sesi.close();
        }

        return return_id;

    }

    //PayOut Search
    public List<CashBoxOut> payOutSearch(String s){

        Session sesi = sf.openSession();
        List<CashBoxOut> ls = new ArrayList();

        try {

            Query query = sesi
                    .createSQLQuery("CALL ProcPayOutSearch(?)")
                    .addEntity(CashBoxOut.class)
                    .setParameter(1,s);
            ls = query.getResultList();

        } catch (Exception e) {
            System.err.println("PayOut Search Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Filter of payment out with Date
    public List<CashBoxOut> allPaymentOutFilterDate(String startDate,String endDate){

        List<CashBoxOut> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            ls = sesi.createSQLQuery("CALL ProcReportCOAOut(?,?)")
                    .addEntity(CashBoxOut.class)
                    .setParameter(1,startDate)
                    .setParameter(2,endDate)
                    .getResultList();

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Payment Out Filter Date Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //Filter of payment out with Date
    public List<CashBoxOut> allPaymentOutFilterDate(String date){

        List<CashBoxOut> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "from CashBoxOut where cbOut_date = :date";
            ls = sesi.createQuery(sql).setParameter("date",date).getResultList();

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("All Payment Out Filter Date Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //=========================================== Cash Box Output Section - End ===========================================//

    //=========================================== View Section - Start ===========================================//

    //View CashBoxIn with CompletedOrder
    public List<View_CashBoxInCompletedOrder> viewCbInCO(){

        List<View_CashBoxInCompletedOrder> ls = new ArrayList<>();

        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "SELECT * FROM viewPayInTable";
            ls = sesi.createSQLQuery(sql).getResultList();

        } catch (Exception e) {
            System.err.println("View CashBoxIn with CompletedOrder Error: " + e);
        } finally {
            sesi.close();
        }
        return ls;
    }

    //View BoxOrder_cuPro List with cu_id
    public List<View_boxOrder_cuPro> viewBoCuPro(int cu_id){

        List<View_boxOrder_cuPro> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "select * from viewboxordertable where cu_id = :cu_id and bo_status = 0";
            Query query = sesi
                    .createSQLQuery(sql)
                    .setParameter("cu_id",cu_id)
                    .addEntity(View_boxOrder_cuPro.class);

            ls = query.getResultList();

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("View BoxOrder_cuPro Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //View BoxOrder_cuPro List
    public List<View_boxOrder_cuPro> viewBoCuPro(){

        List<View_boxOrder_cuPro> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            String sql = "select * from viewboxordertable";
            Query query = sesi
                    .createSQLQuery(sql)
                    .addEntity(View_boxOrder_cuPro.class);

            ls = query.getResultList();

            //=============================Check of Data==========================================//
            /*boxOfOrder bod = new boxOfOrder();
            ls.forEach(it->{
                int boxoforderStatus = boxOfOrderInsert(it.getBo_id(),it.getCu_id(),it.getP_id(),it.getBo_ticketNo(),it.getName_surname(),it.getP_title(),it.getP_salePrice(),it.getBo_total(),it.getBo_totalPrice(),it.getBo_status());
                System.out.println("boxoforderStatus: " + boxoforderStatus);
            });*/
            //=============================Check of Data==========================================//

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("View BoxOrder_cuPro without cu_id Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //View CashBoxIn,CompleteOrder,Customer
    public List<View_CheckOutActions> viewCOATable(int cu_id,String startDate, String endDate){

        List<View_CheckOutActions> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            System.out.println("debUtil id, startDate,endDate: " + cu_id + " " + startDate + " " + endDate);

            ls = sesi.createSQLQuery("CALL ProcReportCOA(?,?,?)")
                    .addEntity(View_CheckOutActions.class)
                    .setParameter(1,cu_id)
                    .setParameter(2,startDate)
                    .setParameter(3,endDate)
                    .getResultList();

            ls.forEach(it->{
                System.out.println("dbUtil: " + it.toString());
            });

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("View CompleteOrder-Customer Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }
    //View CashBoxIn,CompleteOrder,Customer
    public List<View_CheckOutActions> viewCOABoxInTable(String startDate, String endDate){

        List<View_CheckOutActions> ls = new ArrayList();
        Session sesi = sf.openSession();
        tr = sesi.beginTransaction();

        try {

            System.out.println("startDate,endDate: " +startDate + " " + endDate);

            ls = sesi.createSQLQuery("CALL ProcReportCOABoxIn(?,?)")
                    .addEntity(View_CheckOutActions.class)
                    .setParameter(1,startDate)
                    .setParameter(2,endDate)
                    .getResultList();

            ls.forEach(it->{
                System.out.println("dbUtil: " + it.toString());
            });

            tr.commit();

        } catch (Exception e) {
            if (tr != null) {
                tr.rollback();
            }
            System.err.println("View CompleteOrder-Customer Error: " + e);
        } finally {
            sesi.close();
        }

        return ls;

    }

    //=========================================== View Section - End ===========================================//





}
