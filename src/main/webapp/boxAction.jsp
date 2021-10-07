<%@ page import="Entities.User" %>
<%@ page import="java.util.List" %>
<%@ page import="Entities.View_boxOrder_cuPro" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="util" class="Utils.Util"></jsp:useBean>
<jsp:useBean id="dbUtil" class="Utils.DBUtil"></jsp:useBean>
<% User user = util.isLogin(request,response); %>

<!doctype html>
<html lang="en">

<head>
    <title>Satış</title>
    <jsp:include page="inc/css.jsp"></jsp:include>
</head>

<body>

<div class="wrapper d-flex align-items-stretch">
    <jsp:include page="inc/slideBar.jsp"></jsp:include>
    <div id="content" class="p-4 p-md-5">
        <jsp:include page="inc/topMenu.jsp"></jsp:include>
        <h3 class="mb-3">
            Satış Yap
            <small class="h6">Satış Yönetim Paneli</small>
        </h3>

        <div class="main-card mb-3 card mainCart">
            <div class="card-header cardHeader">Yeni Satış</div>

            <form class="row p-3" id="sale_add_form">

                <div class="col-md-3 mb-3">
                    <label for="cnameSelect" class="form-label">Müşteriler</label>
                    <select id="cnameSelect" class="selectpicker" data-width="100%" data-show-subtext="true" data-live-search="true" required>
                        <option value="" data-subtext="">Seçim Yapınız</option>
                        <c:if test="${ dbUtil.allCustomer().size() > 0 }">
                            <c:forEach items="${dbUtil.allCustomer()}" var="item">
                                <option value="${item.cu_id}" data-subtext="${item.cu_code}"><c:out value="${item.cu_name}  ${item.cu_surname}"></c:out></option>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>

                <div class="col-md-3 mb-3">
                    <label for="pnameSelect" class="form-label">Ürünler</label>
                    <select id="pnameSelect" class="selectpicker" data-width="100%" data-show-subtext="true" data-live-search="true" required>
                        <option value="" data-subtext="">Seçim Yapınız</option>
                        <c:if test="${dbUtil.allProduct().size() > 0}">
                            <c:forEach items="${dbUtil.allProduct()}" var="item">
                                <c:if test="${item.p_quantity > 0}">
                                    <option value="${item.p_id}" data-subtext=" (Stok: ${item.p_quantity})"><c:out value="${item.p_title}"></c:out></option>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>


                <div class="col-md-3 mb-3">
                    <label for="count" class="form-label">Adet</label>
                    <input type="number" min="1" max="100" name="count" id="count" class="form-control" required/>
                </div>


                <div class="col-md-3 mb-3">
                    <label for="bNo" class="form-label">Fiş No</label>
                    <input type="text" min="1" max="100" name="bNo" id="bNo" class="form-control" />
                </div>

                <div class="btn-group col-md-3 " role="group">
                    <button type="submit" class="btn btn-outline-primary mr-1">Ekle</button>
                </div>
            </form>
        </div>


        <div class="main-card mb-3 card mainCart">
            <div class="card-header cardHeader">Sepet Ürünleri</div>


            <div class="table-responsive">
                <table class="align-middle mb-0 table table-borderless table-striped table-hover">
                    <thead>
                    <tr>
                        <th>BId</th>
                        <th>Ürün</th>
                        <th>Birim Fiyat (₺)</th>
                        <th>Adet</th>
                        <th>Müşteri</th>
                        <th>Toplam Fiyat (₺)</th>
                        <th>Fiş No</th>
                        <th class="text-center" style="width: 55px;" >Sil</th>
                    </tr>
                    </thead>
                    <tbody id="salesTable">
                    <!-- for loop  -->

                    </tbody>
                </table>
            </div>
        </div>

        <div class="btn-group col-md-3 " role="group">
            <button onclick="fncCompletedOrder()" type="button" class="btn btn-outline-primary mr-1">Satışı Tamamla</button>
        </div>

        <div class="row">
            <div class="col-md-3 mb-3"></div>
            <div class="col-md-3 mb-3"></div>
            <div class="col-md-3 mb-3"></div>
            <div class="col-md-3 mb-3">
                <div class="card cardBackground3" id="card">
                    <div class="card-body" style="background: #3d64ff">
                        <div style="display: flex; justify-content: space-between;">
                            <h5 style="align-self: center;"> Toplam Tutar </h5>
                            <h4 id="totalPrice" > <strong> 0 ₺ </strong> </h4>
                        </div>
                    </div>
                </div>
            </div>
        </div>



    </div>
</div>
</div>
<jsp:include page="inc/js.jsp"></jsp:include>
<script src="js/boxAction.js"></script>
</body>

</html>

