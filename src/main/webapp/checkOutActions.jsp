<%@ page import="Entities.User" %>
<%@ page import="Entities.CompletedOrder" %>
<%@ page import="Entities.CashBoxOut" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Entities.CashBoxIn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="util" class="Utils.Util"></jsp:useBean>
<jsp:useBean id="dbUtil" class="Utils.DBUtil"></jsp:useBean>
<% User user = util.isLogin(request,response); %>

<!doctype html>
<html lang="en">

<head>
    <title>Kasa</title>
    <jsp:include page="inc/css.jsp"></jsp:include>
</head>

<body>

<div class="wrapper d-flex align-items-stretch">
    <jsp:include page="inc/slideBar.jsp"></jsp:include>
    <div id="content" class="p-4 p-md-5">
        <jsp:include page="inc/topMenu.jsp"></jsp:include>

        <h3 class="mb-3">
            Kasa
            <small class="h6">Kasa Hareketleri</small>
        </h3>

        <div class="row">

            <div class="col-sm-4 mb-3">
                <div class="card cardBackground1" id="card">
                    <div class="card-body">
                        <div style="display: flex; justify-content: space-between;">
                            <h5 style="align-self: center;">Toplam Kasaya Giren</h5>
                            <% int totalIn = dbUtil.allcompletedOrder().stream().mapToInt(CompletedOrder::getCo_amountPaid).sum(); %>
                            <h4><strong> <%=totalIn%>₺ </strong></h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-4 mb-3">
                <div class="card cardBackground2" id="card">
                    <div class="card-body">
                        <div style="display: flex; justify-content: space-between;">
                            <h5 style="align-self: center;">Toplam Kasadan Çıkan</h5>
                            <% int totalOut = dbUtil.allPaymentOut().stream().mapToInt(CashBoxOut::getCbOut_payAmount).sum(); %>
                            <h4><strong> <%=totalOut%>₺ </strong></h4>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-4 mb-3">
                <div class="card cardBackground3" id="card">
                    <div class="card-body">
                        <div style="display: flex; justify-content: space-between;">
                            <h5 style="align-self: center;"> Kasada Kalan</h5>
                            <h4><strong> <%=totalIn-totalOut%>₺ </strong></h4>
                        </div>
                    </div>
                </div>
            </div>
            <%
                Date date = new Date();
                String nowDate = new SimpleDateFormat("yyyy-MM-dd").format(date);
            %>

            <div class="col-sm-4 mb-3">
                <div class="card cardBackground4" id="card">
                    <div class="card-body">
                        <div style="display: flex; justify-content: space-between;">
                            <h5 style="align-self: center;"> Bugün Kasaya Giriş</h5>
                            <% int todayTotalIn = dbUtil.allPaymentInFilterDate(nowDate).stream().mapToInt(CashBoxIn::getCbIn_payAmount).sum(); %>
                            <h4><strong> <%=todayTotalIn%>₺ </strong></h4>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-4 mb-3">
                <div class="card cardBackground4" id="card">
                    <div class="card-body">
                        <div style="display: flex; justify-content: space-between;">
                            <h5 style="align-self: center;"> Bugün Kasadan Çıkan</h5>
                            <% int todayTotalOut = dbUtil.allPaymentOutFilterDate(nowDate).stream().mapToInt(CashBoxOut::getCbOut_payAmount).sum(); %>
                            <h4><strong> <%=todayTotalOut%>₺ </strong></h4>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-4 mb-3">
                <a href="payIn.jsp">
                    <div class="card cardBackground4" id="card">
                        <div class="card-body">
                            <div style="display: flex; justify-content: space-between;">
                                <h5 style="align-self: center;"> Kasa Yönetimi</h5>
                                <i class="fas fa-link fa-2x" style="color: white; align-self: center;"></i>
                            </div>
                        </div>
                    </div>
                </a>
            </div>


        </div>

        <div class="main-card mb-3 card mainCart">
            <div class="card-header cardHeader">Arama / Rapor</div>

            <form class="row p-3" id="reportForm">

                <div class="col-md-3 mb-3">
                    <label for="cnameSelect" class="form-label">Müşteriler</label>
                    <select id="cnameSelect" class="selectpicker" data-width="100%" data-show-subtext="true" data-live-search="true" required>
                        <option value="" data-subtext="">Seçim Yapınız</option>
                        <c:if test="${ dbUtil.allCustomer().size() > 0 }">
                            <option value="-1" >Kasa</option>
                            <c:forEach items="${dbUtil.allCustomer()}" var="item">
                                <option value="${item.cu_id}" data-subtext="${item.cu_code}"><c:out value="${item.cu_name}  ${item.cu_surname}"></c:out></option>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>

                <div class="col-md-3 mb-3">
                    <label for="processType" class="form-label">Tür</label>
                    <select class="form-select" name="ctype" id="processType">
                        <option value="">Seçim Yapınız</option>
                        <option value="1">Giriş</option>
                        <option value="2">Çıkış</option>
                    </select>
                </div>

                <div class="col-md-3 mb-3">
                    <label for="startDate" class="form-label">Başlama Tarihi</label>
                    <input type="date" name="startDate" id="startDate" class="form-control" />
                </div>

                <div class="col-md-3 mb-3">
                    <label for="endDate" class="form-label">Bitiş Tarihi</label>
                    <input type="date" name="endDate" id="endDate" class="form-control" />
                </div>

                <div class="col-md-3">
                    <button type="submit" class="col btn btn-outline-primary">Gönder</button>
                </div>
            </form>
        </div>

        <div class="main-card mb-3 card mainCart">
            <div class="card-header cardHeader">Arama Sonuçları</div>

            <div class="table-responsive" >

                <table class="align-middle mb-0 table table-borderless table-striped table-hover" id="reportCOATable">


                </table>

            </div>

            <div class="main-card mb-3 card mainCart">

                <div class="table-responsive" >

                    <table class="align-middle mb-0 table table-borderless table-striped table-hover" id="reportCOAOutTable">


                    </table>

            </div>

            <div class="main-card mb-3 card mainCart">

                <div class="table-responsive" >

                    <table class="align-middle mb-0 table table-borderless table-striped table-hover" id="reportCOAInTable">


                    </table>

                </div>




        </div>


    </div>
</div>
</div>
<jsp:include page="inc/js.jsp"></jsp:include>
<script src="js/checkOutActions.js"></script>
</body>
</html>
