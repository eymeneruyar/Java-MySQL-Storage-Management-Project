<%@ page import="Entities.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="util" class="Utils.Util"></jsp:useBean>
<jsp:useBean id="dbUtil" class="Utils.DBUtil"></jsp:useBean>
<% User user = util.isLogin(request,response); %>

<!doctype html>
<html lang="en">

<head>
    <title>Kasa Yönetimi / Ödeme Girişi</title>
    <jsp:include page="inc/css.jsp"></jsp:include>
</head>

<body>

<div class="wrapper d-flex align-items-stretch">
    <jsp:include page="inc/slideBar.jsp"></jsp:include>
    <div id="content" class="p-4 p-md-5">
        <jsp:include page="inc/topMenu.jsp"></jsp:include>
        <h3 class="mb-3">
            <a href="payOut.jsp" class="btn btn-danger float-right">Ödeme Çıkışı</a>
            Kasa Yönetimi
            <small class="h6">Ödeme Girişi</small>
        </h3>



        <div class="main-card mb-3 card mainCart">
            <div class="card-header cardHeader">Ödeme Ekle</div>

            <form class="row p-3" id="payIn_form">

                <div class="col-md-3 mb-3">
                    <label for="cnamePayIn" class="form-label">Müşteriler</label>
                    <select id="cnamePayIn" class="selectpicker" data-width="100%" data-show-subtext="true" data-live-search="true" required>
                        <option value="" data-subtext="">Seçim Yapınız</option>
                        <c:if test="${ dbUtil.allcompletedOrder().size() > 0 }">
                            <c:forEach items="${dbUtil.allcompletedOrder()}" var="item">
                                <c:if test="${item.co_avail != 0}">
                                    <option value="${item.c_id}" data-subtext=" - ${item.co_ticketNo} "><c:out value="${item.co_nameSurname} "></c:out></option>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>

                <div class="col-md-3 mb-3">
                    <label for="cuTicketNoPayIn" class="form-label">Müşteri Fişleri</label>
                    <select id="cuTicketNoPayIn" class="selectpicker" data-width="100%" data-show-subtext="true" data-live-search="true" required>
                        <option value="" data-subtext="">Seçim Yapınız</option>
                        <c:if test="${ dbUtil.allcompletedOrder().size() > 0 }">
                            <c:forEach items="${dbUtil.allcompletedOrder()}" var="item">
                                <c:if test="${item.co_avail != 0}">
                                    <option value="${item.co_ticketNo}" data-subtext=" - ${item.co_avail} ₺"><c:out value="${item.co_ticketNo}"></c:out></option>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>

                <div class="col-md-3 mb-3">
                    <label for="payInTotal" class="form-label">Ödeme Tutarı</label>
                    <input  type="number" name="payInTotal" id="payInTotal" class="form-control" />
                </div>

                <div class="col-md-3 mb-3">
                    <label for="payInDetail" class="form-label">Ödeme Detay</label>
                    <input type="text" name="payInDetail" id="payInDetail" class="form-control" />
                </div>




                <div class="btn-group col-md-3 " role="group">
                    <button type="submit" class="btn btn-outline-primary mr-1">Gönder</button>
                    <button type="reset" class="btn btn-outline-primary">Temizle</button>
                </div>
            </form>
        </div>


        <div class="main-card mb-3 card mainCart">
            <div class="card-header cardHeader">Ödeme Giriş Listesi</div>

            <div class="row mt-3" style="padding-right: 15px; padding-left: 15px;">
                <div class="col-sm-3"></div>
                <div class="col-sm-3"></div>
                <div class="col-sm-3"></div>
                <div class="col-sm-3">
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text" id="addon-wrapping"><i class="fas fa-search"></i></span>
                        <input id="payInSearch" type="text" class="form-control" placeholder="Arama.." aria-label="Username" aria-describedby="addon-wrapping">

                    </div>
                </div>



            </div>
            <div class="table-responsive">
                <table class="align-middle mb-0 table table-borderless table-striped table-hover">
                    <thead>
                    <tr>
                        <th>Id</th>
                        <th>Müşteri</th>
                        <th>Fiş No</th>
                        <th>Ödeme Tutarı</th>
                        <th class="text-center" style="width: 155px;" >Yönetim</th>
                    </tr>
                    </thead>
                    <tbody id="paymentTable">
                    <!-- for loop  -->

                    </tbody>
                </table>
            </div>
        </div>


    </div>
</div>
</div>

<!------------------------------ PayIn Detail Madal - Start ------------------------------------------->
<div class="modal fade" id="paymentDetailModel" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" >
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" style="color: black"   id="cb_customerDetail">Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row ">
                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Fiş No</label>
                        <div style="color: black" id="cb_ticketNoDetail" class="form-text">Mail</div>
                    </div>

                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Ödeme Tutarı</label>
                        <div style="color: black" id="cb_payAmount" class="form-text"></div>
                    </div>

                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Ödeme Detayı</label>
                        <div style="color: black" id="cb_payAmountDetail" class="form-text"></div>
                    </div>

                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Kapat</button>

            </div>
        </div>
    </div>
</div>
<!------------------------------ PayIn Detail Madal - End ------------------------------------------->

<jsp:include page="inc/js.jsp"></jsp:include>
<script src="js/payIn.js"></script>
</body>

</html>

