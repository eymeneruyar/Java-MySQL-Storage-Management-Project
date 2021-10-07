<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Entities.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="util" class="Utils.Util"></jsp:useBean>
<jsp:useBean id="dbUtil" class="Utils.DBUtil"></jsp:useBean>

<% User user = util.isLogin(request,response); %>

<!doctype html>
<html lang="en">
<head>
    <title>Yönetim</title>
    <jsp:include page="inc/css.jsp"></jsp:include>
</head>
<body>
<div class="wrapper d-flex align-items-stretch">
    <jsp:include page="inc/slideBar.jsp"></jsp:include>
    <div id="content" class="p-4 p-md-5">
        <jsp:include page="inc/topMenu.jsp"></jsp:include>

        <h3 class="mb-3">
            Yönetim
            <small class="h6">Yönetim Paneli</small>
        </h3>


        <div class="row">
            <div class="col-sm-6">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="d-grid gap-2">
                            <button onclick="location.href = 'customer.jsp';" class="btn btn-primary btn-lg mb-2 text-left custom_btn button1" type="button"> <i class="fas fa-user-plus"></i> Müşteri Ekle </button>
                            <button onclick="location.href = 'products.jsp';" class="btn btn-warning btn-lg mb-2 text-left custom_btn button2" type="button"> <i class="fa fa-shopping-basket"></i> Ürün Ekle</button>
                            <button onclick="location.href = 'boxAction.jsp';" class="btn btn-success btn-lg mb-2 text-left custom_btn button3" type="button"><i class="fa fa-shopping-cart"></i>  Sipariş Ekle</button>
                            <button onclick="location.href = 'payIn.jsp';" class="btn btn-danger btn-lg mb-2 text-left  custom_btn button4" type="button"><i class="fa fa-window-maximize"></i> Ödeme Girişi</button>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="card mb-3" id="card"
                        >
                            <div class="card-body d-flex flex-row justify-content-between" style="padding-bottom: .6rem;">
                                <div class="card-left">
                                    <div class="card-subtitle mb-1 text-muted" style="opacity: .8; margin-bottom: 0;">Toplam</div>
                                    <div class="card-title" style="font-weight: 700; margin-bottom: 0; letter-spacing: 0.5px;">Müşteri
                                        Hesabı</div>
                                </div>
                                <div class="card-right">
                                    <div style="font-size: 1.8rem;font-weight: 700; color:#22AE78;"><span><%=dbUtil.allCustomer().size()%></span></div>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-3">
                            <div class="card-body d-flex flex-row justify-content-between" style="padding-bottom: .6rem;">
                                <div class="card-left">
                                    <div class="card-subtitle mb-1 text-muted" style="opacity: .8; margin-bottom: 0;">Toplam</div>
                                    <div class="card-title" style="font-weight: 700; margin-bottom: 0; letter-spacing: 0.5px;">Sipariş</div>
                                </div>
                                <div class="card-right">
                                    <div style="font-size: 1.8rem;font-weight: 700; color: #244785;"><span><%=dbUtil.allcompletedOrder().size()%></span></div>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-3">
                            <div class="card-body d-flex flex-row justify-content-between" style="padding-bottom: .6rem;">
                                <div class="card-left">
                                    <div class="card-subtitle mb-1 text-muted" style="opacity: .8; margin-bottom: 0;">Toplam</div>
                                    <div class="card-title" style="font-weight: 700; margin-bottom: 0; letter-spacing: 0.5px;">Stoktaki Ürünler</div>
                                </div>
                                <div class="card-right">
                                    <%
                                        int totalStock = dbUtil.allProduct().stream().mapToInt(Product::getP_quantity).sum();
                                    %>
                                    <div style="font-size: 1.8rem;font-weight: 700;color: #F7B924;"><span><%=totalStock%></span></div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <div id="top_x_div" class="col-sm-6" ></div>

        </div>

        <div class="row mt-5">
            <div class="col-sm-6">
                <div class="main-card mb-3 card mainCart">
                    <div class="card-header cardHeader">Son 5 Stok Ürünü</div>
                    <div class="table-responsive">
                        <table class="align-middle mb-0 table table-borderless table-striped table-hover">
                            <thead>
                            <tr>
                                <th>Id</th>
                                <th>Ürün Kodu</th>
                                <th>Ürün Adı</th>
                                <th>Alış Fiyatı (₺)</th>
                                <th>Satış Fiyatı (₺)</th>
                                <th>Kar (₺)</th>
                                <th>Kalan</th>
                            </tr>
                            </thead>
                            <tbody>
                            <!-- for loop  -->
                            <c:if test="${dbUtil.last5Products().size() > 0}">
                                <c:forEach items="${dbUtil.last5Products()}" var="item">
                                    <tr role="row" class="odd">
                                        <td>${item.p_id}</td>
                                        <td>${item.p_code}</td>
                                        <td>${item.p_title}</td>
                                        <td>${item.p_buyPrice}</td>
                                        <td>${item.p_salePrice}</td>
                                        <td>${item.p_salePrice - item.p_buyPrice}</td>
                                        <td>${item.p_quantity}</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-sm-6">
                <div class="main-card mb-3 card" style="box-shadow: 0 0.46875rem 2.1875rem rgb(4 9 20 / 3%), 0 0.9375rem 1.40625rem rgb(4 9 20 / 3%), 0 0.25rem 0.53125rem rgb(4 9 20 / 5%), 0 0.125rem 0.1875rem rgb(4 9 20 / 3%);border-width: 0;">
                    <div class="card-header" style="text-transform: uppercase;color: rgb(13, 27, 62,0.7);font-weight: 700; font-size: 0.88rem;">Son Siparişler</div>
                    <div class="table-responsive">
                        <table class="align-middle mb-0 table table-borderless table-striped table-hover">
                            <thead>
                            <tr>
                                <th>FişNo</th>
                                <th>Müşteri Adı</th>
                                <th>Tutar (₺)</th>
                            </tr>
                            </thead>
                            <!-- for loop  -->
                            <tbody>
                                <c:if test="${dbUtil.allcompletedOrder().size() > 0}">
                                    <c:forEach items="${dbUtil.allcompletedOrder()}" var="item">
                                        <tr role="row" class="odd">
                                            <td>${item.co_ticketNo}</td>
                                            <td>${item.co_nameSurname}</td>
                                            <td>${item.totalPrice}</td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>



    </div>
</div>
</div>
<jsp:include page="inc/js.jsp"></jsp:include>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script  src="js/dashboard.js"></script>
</body>

</html>
