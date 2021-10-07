package Servlets;

import Utils.DBUtil;
import Utils.Util;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "logInOutServlet", value = {"/login-servlet","/logout-servlet"})
public class LogInOutServlet extends HttpServlet {

    //Login process
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String us_email = req.getParameter("emailForm");
        String us_password = req.getParameter("passwordForm");
        String remember = req.getParameter("rememberForm");

        DBUtil dbUtil = new DBUtil();
        boolean status = dbUtil.login(us_email,us_password,remember,req,resp);
        if( status ){
            resp.sendRedirect(Util.login_page + "dashboard.jsp");
        }else{
            req.setAttribute("loginError","E-mail ya da Şifre Hatalı!");
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/");
            dispatcher.forward(req,resp);
        }

    }

    //Logout process
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        //All Session Delete
        req.getSession().invalidate();

        //Cookies Delete
        Cookie cookie = new Cookie("user","");
        cookie.setMaxAge(0);
        resp.addCookie(cookie);

        resp.sendRedirect(Util.login_page);

    }

}
