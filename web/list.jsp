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
            <h1 class="light">Phân loại</h1>
            <div class="hr"></div>
            <p>
                <h5>Theo tên</h5>
                <div>
                    <input id="keyword" onkeyup="addKeywordToFilter()" type="text" name="search" style="width: calc(100% - 150px)">
                    <button onclick="addKeywordToFilter()" class="wave" type="submit">Tìm ngay</button>
                </div>
            </p>
            <div class="hr"></div>
            <p>
                <h5>Giá tối đa</h5>
                <div>
                    <input id="price-range" type="range" name="price" min="1000" max="1000000" value="1000000" style="width: 100%" onchange="priceChange(this)" oninput="updateMaxPrice(this)">
                    <div id="price-range-viewer">Không giới hạn</div>
                </div>
            </p>
            <div class="hr"></div>
            <p>
                <h5>Trang gốc</h5>
                <div>
                    <c:forEach items="cayvahoa.net,vuoncayviet.com,webcaycanh.com" var="domain" varStatus="counter">
                        <div class="checkbox">
                            <input id="domain-${counter.count}" type="checkbox" name="type" value="senda" onclick="domainCheckboxClick(this, '${domain}')">
                            <label for="domain-${counter.count}">${domain}</label>
                        </div>
                    </c:forEach>
                </div>
            </p>
            <div class="hr"></div>
            <p>
                <h5>Thể loại</h5>
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
            <h1 class="light" id="summary-title">Tất cả ${param.category}</h1>
            <div class="hr"></div>
            <h5 id="summary-description"></h5>
            <div id="products-container" class="grid">
                <c:forEach items="${dao.plantList}" var="item">
                    <div id="product-${item.id}" class="a-product m-5 d-2" data-price="${item.price}" data-name="${item.name}" data-domain="${dao.getDomain(item)}">
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
                            <small class="domain handwriting">${dao.getDomain(item)}</small>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div id="pagination">
                <span>Số sản phẩm trên 1 trang: </span>
                <select class="wave" onchange="changeLimit(this)">
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                    <option value="999999999">Tất cả</option>
                </select>
                <span id="pagination-container"></span>
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
        domains: [],
        keyword: '',
        maxPrice: 1000000
    };
    summary = {
        title: document.getElementById('summary-title'),
        description: document.getElementById('summary-description')
    };
    function updateMaxPrice(that) {
        var price = Number(that.value);
        var viewer = document.getElementById('price-range-viewer');
        if (price === 1000000) {
            viewer.innerHTML = 'Không giới hạn';
            filter.maxPrice = 999999999999;
        } else {
            viewer.innerHTML = formatPrice(price) + ' vnđ';
            filter.maxPrice = price;
        }
    }
    function priceChange(that) {
        updateMaxPrice(that);
        filterAll();
    }
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
    function addDomainToFilter(domain) {
        filter.domains.push(domain);
    }
    function removeDomainFromFilter(domain) {
        filter.domains = filter.domains.filter(function(s) {
            return domain !== s;
        });
    }
    function categoryCheckboxClick(that, category) {
        if (that.checked) {
            addCategoryToFilter(category);
        } else {
            removeCategoryFromFilter(category);
        }
        filterAll();
    }
    function domainCheckboxClick(that, domain) {
        if (that.checked) {
            addDomainToFilter(domain);
        } else {
            removeDomainFromFilter(domain);
        }
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
            var name = product.dataset.name.toLowerCase();
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
    function filterByDomain() {
        if (filter.domains.length === 0) {
            return;
        }
        var products = document.querySelectorAll('.a-product');
        var length = products.length;
        for (var i = 0; i < length; i++) {
            var product = products[i];
            var domain = product.dataset.domain.toLowerCase();
            var check = false;
            for (var j = 0; j < filter.domains.length; j++) {
                var d = filter.domains[j];
                if (domain.indexOf(d) >= 0) {
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
            var name = product.dataset.name.toLowerCase();
            if (name.indexOf(filter.keyword) === -1) {
                hide(product);
            }
        }
    }
    function filterByPrice() {
        var products = document.querySelectorAll('.a-product');
        var length = products.length;
        for (var i = 0; i < length; i++) {
            var product = products[i];
            var price = Number(product.dataset.price);
            if (price > filter.maxPrice) {
                hide(product);
            }
        }
    }
    function fetchMore() {
        summary.description.innerHTML = 'Đang tải thêm sản phẩm...';
        var container = document.getElementById('products-container');
        container.innerHTML = '';
        request({
            action: 'search',
            search: filter.keyword
        }, function(res) {
            var plants = res.responseXML.getElementsByTagName('plant');
            for (var i = 0; i < plants.length; i++) {
                var plant = plants[i];
                container.innerHTML += plant2HTML(plant);
            }
            filterAll(true);
        });
    }
    function countProducts() {
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
            summary.description.innerHTML = 'Không tìm thấy sản phẩm nào.';
        }
        return count;
    }
    function filterAll(finish) {
        summary.title.innerHTML = 'Kết quả tìm kiếm';
        showAll();
        filterByCategory();
        filterByDomain();
        filterByKeyword();
        filterByPrice();
        var count = countProducts();
        if (count === 0 && !finish) {
            fetchMore();
        } else {
            paginate(1);
        }
    }
    countProducts();
    pagination = {
        limit: 10,
        page: 1,
        count: 0
    };
    function changeLimit(that) {
        pagination.limit = that.value;
        paginate(1);
    }
    function clearOutside() {
        var products = document.querySelectorAll('.a-product');
        var length = products.length;
        for (var i = 0; i < length; i++) {
            var product = products[i];
            product.classList.remove('outside');
        }
    }
    function paginate(page) {
        pagination.page = page;
        pagination.count = 0;
        var products = document.querySelectorAll('.a-product');
        var min = pagination.limit*(pagination.page - 1);
        var max = pagination.limit*pagination.page - 1;
        clearOutside();
        for (var i = 0; i < products.length; i++) {
            var product = products[i];
            if (!product.classList.contains('hidden')) {
                if (pagination.count < min || pagination.count > max) {
                    product.classList.add('outside');
                }
                pagination.count++;
            }
        }
        generatePaginations();
    }
    paginate(1);
    function generatePaginations() {
        var container = document.getElementById('pagination-container');
        container.innerHTML = '';
        var n = Math.ceil(pagination.count/pagination.limit)
        for (var i = 1; i <= n; i++) {
            var active = '';
            if (i === pagination.page) {
                active = ' active';
            }
            container.innerHTML += '<a onclick="paginate(' + i + ')" class="wave' + active + '">' + i + '</a>';
        }
    }
</script>
<div id="quick-view-container" onclick="hideQuickview()">
    <iframe id="quick-view" src=""/>
</div>

<jsp:include page="shared/footer.jsp"/>