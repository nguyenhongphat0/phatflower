<%-- 
    Document   : admin
    Created on : Jun 17, 2019, 11:49:23 PM
    Author     : nguyenhongphat0
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Flower Admin</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/grid.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/theme.css">
        <style>
            body > div {
                height: 100%;
            }
            body > .grid > .d-2 {
                position: relative;
                background-color: #151b26;
                box-shadow: 0 0 5px #151b26;
            }
            body > .grid > .d-2 * {
                color: white;
            }
            body > .grid > .d-8 {
                padding: 20px 40px;
            }
            .admin-logo {
                width: 100%;
            }
            .admin-menu .logout {
                position: absolute;
                bottom: 30px;
            }
            .admin-menu .wave {
                display: block;
                width: 100%;
                box-sizing: border-box;
            }
            .cautions {
                font-style: italic;
                font-size: 12px;
            }
            #result {
                font-size: 16px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="grid">
            <div class="d-2">
                <a href="${pageContext.request.contextPath}"><img class="admin-logo" src="${pageContext.request.contextPath}/assets/img/logo.png" title="Phat Flower"/></a>
                <div class="admin-menu">
                    <div class="d-pl-4 d-pt-2 d-pb-2"><small style="color: lightgray">Quản lý sản phẩm</small></div>
                    <a class="wave">Cào sản phẩm</a>
                    <a class="wave">Dọn dẹp sản phẩm</a>
                    <div class="d-pl-4 d-pt-2 d-pb-2"><small style="color: lightgray">Quản lý danh mục</small></div>
                    <a class="wave">Phân loại sản phẩm</a>
                    <div class="d-pl-4 d-pt-2 d-pb-2"><small style="color: lightgray">Quản lý hệ thống</small></div>
                    <a class="wave">Xem log</a>
                    <a class="wave logout" href="index.jsp">&lt; Đăng xuất</a>
                </div>
            </div>
            <div class="d-8">
                <div id="plants-crawl">
                    <h1>Cào sản phẩm</h1>
                    <h2>Nhập đường dẫn để cào</h2>
                    <form name="crawl" onsubmit="crawl">
                        <input type="text" name="url" placeholder="https://cayvahoa.net/hoa-chau"/>
                        <button class="wave" type="submit" value="crawl" name="action">Cào ngay</button>
                    </form>
                    <p>
                        <div>Lưu ý:</div>
                        <ul class="cautions">
                            <li>Đường dẫn phải thuộc 1 trong 3 trang "cayvahoa.net", "vuoncayviet.com" hoặc "webcaycanh.com"</li>
                            <li>Đường dẫn phải bao gồm domain (có hay không có https:// đều được)</li>
                        </ul>
                    </p>
                    <div id="result">
                        
                    </div>
                </div>
            </div>
        </div>
                
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        <script>
            document.forms.crawl.addEventListener('submit', crawl);
            function crawl(e) {
                var result = document.getElementById('result');
                result.innerHTML = "<i>Đang cào sản phẩm...</i>";
                request({
                    action: 'crawl',
                    url: document.forms.crawl.url.value
                }, function(res) {
                    var res = Number(res.responseText);
                    switch (res) {
                        case -2:
                            result.innerHTML = 'Đường dẫn không hợp lệ, vui lòng kiểm tra lại!';
                            break;
                        case -1:
                            result.innerHTML = 'Đường dẫn phải thuộc 1 trong 3 trang "cayvahoa.net", "vuoncayviet.com" hoặc "webcaycanh.com"̣, vui lòng kiểm tra lại!';
                            break;
                        case 0:
                            result.innerHTML = 'Rất tiếc, không cào được sản phẩm nào. Thử lại với trang nào nhiều sản phẩm hơn thử xem!';
                            break;
                        default:
                            result.innerHTML = 'Đã cào được ' + res + ' sản phẩm!';
                            break;
                    }
                    
                });
                e.preventDefault();
                return false;
            }
        </script>
    </body>
</html>