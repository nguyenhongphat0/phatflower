<%-- 
    Document   : all
    Created on : Jun 16, 2019, 10:12:04 PM
    Author     : nguyenhongphat0
--%>

<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="shared/header.jsp"/>
<div class="section">
    <div class="grid container">
        <div class="m-10 d-3 d-pr-4">
            <h3>Phân loại</h3>
            <div class="hr"></div>
            <p>
                <small><b>Theo tên</b></small>
                <div>
                    <input id="keyword" onkeyup="addKeywordToFilter()" type="text" name="search" style="width: calc(100% - 150px)">
                    <button onclick="addKeywordToFilter()" class="wave" type="submit">Tìm ngay</button>
                </div>
            </p>
            <div class="hr"></div>
            <p>
                <small><b>Thể loại</b></small>
                <div>
                    <c:import var="xml" url="WEB-INF/xml/categories.xml" charEncoding="UTF-8"></c:import>
                    <x:parse var="doc" doc="${xml}"></x:parse>
                    <x:set var="categories" select="$doc//*[name()='category' and (*[name()='enable']='true')]"></x:set>
                    <x:forEach select="$categories" var="category" varStatus="counter">
                        <x:set var="name" select="$category/*[name()='name']"></x:set>
                        <div class="checkbox">
                            <input id="type-${counter.count}" type="checkbox" name="type" value="senda" onclick="categoryCheckboxClick(this, '<x:out select="$name"></x:out>')">
                            <label for="type-${counter.count}" class="capitalize">
                                <x:out select="$name"></x:out>
                            </label>
                        </div>
                    </x:forEach>
                </div>
            </p>
        </div>
        <div class="m-10 d-7 relative">
            <form class="absolute" target="_blank" method="POST" action="FrontController?action=exportPDF" style="right: 0; top: 15px">
                <input type="hidden" name="ids" id="export-ids">
                <button type="submit" class="wave">Xuất ra PDF</button>
            </form>
            <h3 id="summary-title">Tất cả ${param.category}</h3>
            <div class="hr"></div>
            <small id="summary-description"></small>
            <div id="products-container" class="grid">
                <c:forEach items="${dao.plantList}" var="item">
                    <div id="product-${item.id}" class="a-product m-5 d-2">
                        <div class="overlay">
                            <div class="center">
                                <a class="wave" onclick="quickview(${item.id})">Xem nhanh</a>
                                <div class="d-pb-2"></div>
                                <a href="FrontController?action=detail&id=${item.id}" href="#" class="wave">So sánh giá</a>
                                <div class="d-pb-2"></div>
                                <a target="_blank" href="${item.link}" class="wave">Đến trang gốc</a>
                            </div>
                        </div>
                        <div class="preview">
                            <img src="${item.image}" alt="${item.name}">
                        </div>
                        <div class="meta">
                            <h4 class="name">${item.name}</h4>
                            <span class="price">${dao.getReadablePrice(item)} vnđ</span><br/>
                            <small class="handwriting">${dao.getDomain(item)}</small>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>
<script>
    function quickview(id) {
        var container = document.getElementById('quick-view-container');
        var qv = document.getElementById('quick-view');
        container.classList.add('show');
        qv.src = 'FrontController?action=detail&quickview=true&id=' + id;
    }
    function hideQuickview() {
        var container = document.getElementById('quick-view-container');
        container.classList.remove('show');
    }
    function show(product) {
        product.classList.remove('hidden');
    }
    function hide(product) {
        product.classList.add('hidden');
    }
    function showAll() {
        var products = document.querySelectorAll('.a-product');
        var length = products.length;
        for (var i = 0; i < length; i++) {
            var product = products[i];
            show(product);
        }
    }
    filter = {
        categories: [],
        keyword: ''
    };
    summary = {
        title: document.getElementById('summary-title'),
        description: document.getElementById('summary-description')
    };
    function addKeywordToFilter() {
        var keyword = document.getElementById('keyword').value;
        filter.keyword = keyword.trim();
        filterAll();
    }
    function addCategoryToFilter(category) {
        filter.categories.push(category);
    }
    function removeCategoryFromFilter(category) {
        filter.categories = filter.categories.filter(function(c) {
            return category !== c;
        });
    }
    function categoryCheckboxClick(that, category) {
        if (that.checked) {
            addCategoryToFilter(category);
        } else {
            removeCategoryFromFilter(category);
        }
        summary.title.innerHTML = 'Kết quả tìm kiếm';
        filterAll();
    }
    function filterByCategory() {
        if (filter.categories.length === 0) {
            return;
        }
        var products = document.querySelectorAll('.a-product');
        var length = products.length;
        for (var i = 0; i < length; i++) {
            var product = products[i];
            var name = product.getElementsByClassName('name')[0].innerHTML.toLowerCase();
            var check = false;
            for (var j = 0; j < filter.categories.length; j++) {
                var category = filter.categories[j];
                if (name.indexOf(category) >= 0) {
                    check = true;
                }
            }
            if (!check) {
                hide(product);
            }
        }
    }
    function filterByKeyword() {
        var products = document.querySelectorAll('.a-product');
        var length = products.length;
        for (var i = 0; i < length; i++) {
            var product = products[i];
            var name = product.getElementsByClassName('name')[0].innerHTML.toLowerCase();
            if (name.indexOf(filter.keyword) === -1) {
                hide(product);
            }
        }
    }
    function fetchMore() {
        var container = document.getElementById('products-container');
        container.innerHTML = '';
        request({
            action: 'search',
            search: filter.keyword
        }, function(res) {
            var plants = res.responseXML.getElementsByTagName('plant');
            for (var i = 0; i < plants.length; i++) {
                var plant = plants[i];
                var id = plant.querySelector('id').textContent;
                var name = plant.querySelector('name').textContent;
                var price = plant.querySelector('price').textContent;
                var link = plant.querySelector('link').textContent;
                var image = plant.querySelector('image').textContent;
                container.innerHTML += '<div id="product-'+ id +'" class="a-product m-5 d-2"><div class="overlay"><div class="center"><a href="#" class="wave" onclick="quickview(' + id + ')">Xem nhanh</a><div class="d-pb-2"></div><a href="FrontController?action=detail&id=' + id + '" class="wave">So sánh giá</a><div class="d-pb-2"></div><a target="_blank" href="' + link + '" class="wave">Đến trang gốc</a></div></div><div class="preview"><img src="' + image + '" alt="' + name + '"></div><div class="meta"><h4 class="name">' + name + '</h4><span class="price">' + formatPrice(price) + ' vnđ</span><br/><small class="handwriting">' + getDomain(link) + '</small></div></div>'
            }
            filterByCategory();
            countProducts(false);
        });
    }
    function countProducts(fetchMoreIfNone) {
        var count = 0;
        var ids = [];
        var products = document.querySelectorAll('.a-product');
        var length = products.length;
        for (var i = 0; i < length; i++) {
            var product = products[i];
            if (!product.classList.contains('hidden')) {
                count++;
                var id = product.id.replace(/\D*/, '');
                ids.push(id);
            }
        }
        if (count > 0) {
            summary.description.innerHTML = 'Có ' + count + ' sản phẩm phù hợp';
            document.getElementById('export-ids').value = ids.join(',');
        } else {
            if (fetchMoreIfNone) {
                summary.description.innerHTML = 'Đang tải thêm sản phẩm...';
                fetchMore();
            } else {
                summary.description.innerHTML = 'Không tìm thấy sản phẩm nào.';
            }
        }
    }
    function filterAll() {
        showAll();
        filterByCategory();
        filterByKeyword();
        countProducts(true);
    }
    countProducts(true);
</script>
<div id="quick-view-container" onclick="hideQuickview()">
    <iframe id="quick-view" src=""/>
</div>

<jsp:include page="shared/footer.jsp"/>