package Utils;

import Entities.User;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Util {

    public static final String login_page = "http://localhost:8080/depoProject_war_exploded/";

    public User isLogin(HttpServletRequest req, HttpServletResponse resp){

        if(req.getSession() != null){
            Cookie[] cookies = req.getCookies();
            for(Cookie cookie: cookies){
                if(cookie.getName().equals("user")){
                    String values = cookie.getValue();
                    try{
                        String[] arr = values.split("_");
                        req.getSession().setAttribute("us_id",Integer.parseInt(arr[0]));
                        req.getSession().setAttribute("us_name",arr[1]);
                        req.getSession().setAttribute("us_surname",arr[2]);
                    }catch(Exception e){
                        Cookie cookie1 = new Cookie("user","");
                        cookie1.setMaxAge(0);
                        resp.addCookie(cookie1);
                        System.err.println("Is Login Cookie Error: " + e);
                    }
                    break;
                }
            }
        }

        Object sesiObj = req.getSession().getAttribute("us_id");
        User user = new User();
        if(sesiObj == null){
            try {
                resp.sendRedirect(Util.login_page);
            } catch (Exception e) {
                System.err.println("Is Login Session Error: " + e);
            }
        }else{
            int us_id = (int) req.getSession().getAttribute("us_id");
            String us_name = (String) req.getSession().getAttribute("us_name");
            String us_surname = (String) req.getSession().getAttribute("us_surname");
            user.setUs_id(us_id);
            user.setUs_name(us_name);
            user.setUs_surname(us_surname);
        }
        return user;
    }

}
