<%@ page import="Entities.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="util" class="Utils.Util"></jsp:useBean>
<% User user = util.isLogin(request,response); %>

<!doctype html>
<html lang="en">

<head>
    <title>Ürünler</title>
    <jsp:include page="inc/css.jsp"></jsp:include>
</head>

<body>

<div class="wrapper d-flex align-items-stretch">
    <jsp:include page="inc/slideBar.jsp"></jsp:include>
    <div id="content" class="p-4 p-md-5">
        <jsp:include page="inc/topMenu.jsp"></jsp:include>
        <h3 class="mb-3">
            Ürünler
            <small class="h6">Ürün Paneli</small>
        </h3>

        <div class="main-card mb-3 card mainCart">
            <div class="card-header cardHeader">Ürün Ekle</div>

            <form class="row p-3" id="product_add_form">
                <div class="col-md-3 mb-3">
                    <label for="ptitle" class="form-label">Başlık</label>
                    <input type="text" name="ptitle" id="ptitle" class="form-control" required/>
                </div>
                <div class="col-md-3 mb-3">
                    <label for="aprice" class="form-label">Alış Fiyatı (₺)</label>
                    <input type="number" name="aprice" id="aprice" class="form-control" required/>
                </div>
                <div class="col-md-3 mb-3">
                    <label for="oprice" class="form-label">Satış Fiyatı (₺)</label>
                    <input type="number" name="oprice" id="oprice" class="form-control" required/>
                </div>
                <div class="col-md-3 mb-3">
                    <label for="pcode" class="form-label">Ürün Kodu</label>
                    <input type="number" name="pcode" id="pcode" class="form-control" />
                </div>


                <div class="col-md-3 mb-3">
                    <label for="ptax" class="form-label">KDV</label>
                    <select class="form-select" name="ptax" id="ptax" required>
                        <option value="">Seçiniz</option>
                        <option value="0">Dahil</option>
                        <option value="1">%1</option>
                        <option value="2">%8</option>
                        <option value="3">%18</option>
                    </select>
                </div>

                <div class="col-md-3 mb-3">
                    <label for="psection" class="form-label">Birim</label>
                    <select class="form-select" name="psection" id="psection" required>
                        <option value="">Seçiniz</option>
                        <option value="0">Adet</option>
                        <option value="1">KG</option>
                        <option value="2">Metre</option>
                        <option value="3">Paket</option>
                        <option value="4">Litre</option>
                    </select>
                </div>

                <div class="col-md-3 mb-3">
                    <label for="size" class="form-label">Miktar</label>
                    <input type="number" name="size" id="size" class="form-control" required/>
                </div>

                <div class="col-md-3 mb-3">
                    <label for="pdetail" class="form-label">Ürün Detay</label>
                    <input type="text" name="pdetail" id="pdetail" class="form-control" />
                </div>


                <div class="btn-group col-md-3 " role="group">
                    <button type="submit" class="btn btn-outline-primary mr-1">Gönder</button>
                    <button type="reset" class="btn btn-outline-primary">Temizle</button>
                </div>
            </form>
        </div>


        <div class="main-card mb-3 card mainCart">
            <div class="card-header cardHeader">Ürün Listesi</div>

            <!-- Product Search Section -->
            <div class="row mt-3" style="padding-right: 15px; padding-left: 15px;">
                <div class="col-sm-3"></div>
                <div class="col-sm-3"></div>
                <div class="col-sm-3"></div>
                <div class="col-sm-3">
                    <form id="product_search_form">
                        <div class="input-group flex-nowrap">
                            <span class="input-group-text" id="addon-wrapping"><i class="fas fa-search"></i></span>
                            <input id="psearch" type="text" class="form-control" placeholder="Arama.." aria-label="Username" aria-describedby="addon-wrapping">

                        </div>
                    </form>
                </div>
            </div>

            <!-- Product Search Section -->

            <div class="table-responsive">
                <table class="align-middle mb-0 table table-borderless table-striped table-hover">
                    <thead>
                    <tr>
                        <th>Uid</th>
                        <th>Başlık</th>
                        <th>Alış Fiyatı (₺)</th>
                        <th>Satış Fiyatı (₺)</th>
                        <th>Kod</th>
                        <th>KDV</th>
                        <th>Birim</th>
                        <th>Miktar</th>
                        <th class="text-center" style="width: 155px;" >Yönetim</th>
                    </tr>
                    </thead>
                    <tbody id="productTable">
                    <!-- for loop  -->

                    </tbody>
                </table>
            </div>
        </div>


    </div>
</div>

<!-- Product Detail Modal -->
<div class="modal fade" id="productDetailModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" >
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" style="color: black"   id="p_title">Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row ">
                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Alış Fiyatı (₺)</label>
                        <div style="color: black" id="p_buyPrice" class="form-text"></div>
                    </div>

                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Satış Fiyatı (₺)</label>
                        <div style="color: black" id="p_salePrice" class="form-text"></div>
                    </div>

                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Ürün Kodu</label>
                        <div style="color: black" id="p_code" class="form-text"></div>
                    </div>

                    <div class="col-md-3 mb-3">
                        <label  class="form-label">KDV</label>
                        <div style="color: black" id="p_vat" class="form-text"></div>
                    </div>

                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Birim</label>
                        <div style="color: black"  id="p_unit" class="form-text"></div>
                    </div>

                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Miktar</label>
                        <h5 style="color: black"  id="p_quantity" class="form-text"></h5>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label  class="form-label">Ürün Detayı</label>
                        <h5 style="color: black "  id="p_detail" class="form-text"></h5>
                    </div>

                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Kapat</button>

            </div>
        </div>
    </div>
</div>

<jsp:include page="inc/js.jsp"></jsp:include>
<script src="js/stockMan.js"></script>
</body>

</html>

