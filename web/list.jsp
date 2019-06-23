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
                <small><b>Màu sắc</b></small>
                <div>
                    <div class="a-color" style="background: #123456">
                        <div class="amount">10</div>
                    </div>
                    <div class="a-color" style="background: #fafafa">
                        <div class="amount">5</div>
                    </div>
                    <div class="a-color" style="background: #E84C3D">
                        <div class="amount">230</div>
                    </div>
                    <div class="a-color" style="background: #F39C11">
                        <div class="amount">3</div>
                    </div>
                    <div class="a-color" style="background: #dce3f7">
                        <div class="amount">2</div>
                    </div>
                    <div class="a-color" style="background: #861850">
                        <div class="amount">4</div>
                    </div>
                    <div class="a-color" style="background: #A0D468">
                        <div class="amount">171</div>
                    </div>
                    <div class="a-color" style="background: var(--accent)">
                        <div class="amount">33</div>
                    </div>
                </div>
            </p>
            <div class="hr"></div>
            <p>
                <small><b>Phân loại</b></small>
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
        <div class="m-10 d-7">
            <h3 id="summary-title">Tất cả cây cảnh</h3>
            <div class="hr"></div>
            <small id="summary-description"></small>
            <div class="grid">
                <c:forEach items="${dao.plantList}" var="item" varStatus="counter">
                    <div id="product-${counter.count}" class="a-product m-5 d-2">
                        <div class="overlay">
                            <div class="center">
                                <a target="_blank" href="${item.link}" class="wave">Go to site</a>
                                <div class="d-pb-2"></div>
                                <a href="ViewDetailController?id=${item.id}" class="wave">View detail</a>
                                <div class="d-pb-2"></div>
                                <a href="#" class="wave">Comparison</a>
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
    function show(product) {
        product.classList.remove('hidden');
    }
    function hide(product) {
        product.classList.add('hidden');
    }
    function hideAll(products) {
        products.forEach(function(product) {
            hide(product);
        });
    }
    filter = {
        categories: []
    };
    summary = {
        title: document.getElementById('summary-title'),
        description: document.getElementById('summary-description')
    };
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
        filterByCategory();
    }
    function filterByCategory() {
        var products = document.querySelectorAll('.a-product');
        var count = 0;
        hideAll(products);
        products.forEach(function(product) {
            var name = product.getElementsByClassName('name')[0].innerHTML.toLowerCase();
            var check = false;
            filter.categories.forEach(function(category) {
                if (name.indexOf(category) >= 0) {
                    check = true;
                }
            });
            if (check) {
                show(product);
                count++;
            }
        });
        if (count > 0) {
            summary.description.innerHTML = 'Có ' + count + ' sản phẩm phù hợp';
        } else {
            summary.description.innerHTML = 'Không tìm thấy sản phẩm nào';
        }
        
    }
</script>
<jsp:include page="shared/footer.jsp"/>