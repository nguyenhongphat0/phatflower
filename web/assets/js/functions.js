function request(params, callback) {
    var xhttp = new XMLHttpRequest();
    if (!xhttp) {
        try {
            xmlHttp = new ActiveXObject('Msxml12.XMLHTTP');
        } catch (e) {
            xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
        }
    }
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            callback(xhttp);
        }
    };
    xhttp.open("POST", "FrontController", true);
    xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhttp.send(querialize(params));
}

function querialize(params) {
    var list = [];
    for (var key in params) {
        list.push(encodeURIComponent(key) + "=" + encodeURIComponent(params[key]));
    }
    return list.join("&");
}

function formatPrice(price) {
    return price.match(/.{1,3}/g).join(',');
}

function getDomain(url) {
    var domain = url;
    domain = domain.substring(domain.indexOf("//") + 2);
    domain = domain.substring(0, domain.indexOf("/"));
    return domain;
}

function plant2HTML(plant, noquickview) {
    var id = plant.querySelector('id').textContent;
    var name = plant.querySelector('name').textContent;
    var price = plant.querySelector('price').textContent;
    var link = plant.querySelector('link').textContent;
    var image = plant.querySelector('image').textContent;
    var quickview = '<div class="d-pt-4"></div>';
    if (!noquickview) {
        quickview = '<a href="#" class="wave" onclick="quickview(' + id + ')">Xem nhanh</a><div class="d-pb-2"></div>';
    }
    return '<div id="product-'+ id +'" class="a-product m-5 d-2"><div class="overlay"><div class="center">' + quickview + '<a href="FrontController?action=detail&id=' + id + '" class="wave">So sánh giá</a><div class="d-pb-2"></div><a target="_blank" href="' + link + '" class="wave">Đến trang gốc</a></div></div><div class="preview"><img src="' + image + '" alt="' + name + '"></div><div class="meta"><h4 class="name">' + name + '</h4><span class="price">' + formatPrice(price) + ' vnđ</span><br/><small class="handwriting">' + getDomain(link) + '</small></div></div>';
}