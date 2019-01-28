<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date date = new Date();
    String nowDate = sdf.format(date);
%>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="<%=basePath%>/static/layui/css/layui.css"/>
    <link rel="stylesheet" href="<%=basePath%>/static/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="<%=basePath%>/static/editormd/editormd.min.css"/>
</head>
<body>
<div class="container" style="width:80%;">
    <div style="margin-top: 60px;">
        <fieldset class="layui-elem-field layui-field-title">
            <legend style="margin-left: 20px;padding: 0 10px;text-align: left;width: 100px;border-bottom: none;">
                <strong>帖子撰写</strong>
            </legend>
        </fieldset>
    </div>
    <br/>
    <!-- 编辑器的表单 -->
    <div class="layui-form">
        <form action="<%=basePath%>/" method="post">
            <div class="layui-inline" style="margin-left: -10px;">

                <label class="layui-form-label" style="padding-left: 0;"><strong>文章作者</strong></label>
                <div class="layui-input-inline" style="margin-left:-255px;">
                    <input type="text" name="r_author" id="r_author" value="${sessionScope.name}" class="layui-input"/>
                </div>

                <label class="layui-form-label" style="margin-left:169px;padding-left: 0;"><strong>发布日期</strong></label>
                <div class="layui-input-inline" style="margin-left: 88px;">
                    <input type="text" name="r_date" id="r_date" value="<%=nowDate%>" class="layui-input"
                           readonly="readonly"/>
                </div>
            </div>
            <hr style="margin-top: 0;"/>
            <div class="layui-inline" style="margin-left: -10px;padding-left: 0;">

                <label class="layui-form-label" style="padding-left: 0;"><strong>帖子简介</strong></label>
                <div class="layui-input-inline" style="margin-left: -380px;width: 275px;">
                    <input type="text" name="r_summary" id="r_summary" placeholder="请用简短的文字介绍一下你的帖子吧！"
                           class="layui-input"/>
                </div>

                <label class="layui-form-label" style="margin-left:300px;padding-left: 0;"><strong>版块</strong></label>
                <div class="layui-input-inline" style="margin-left: 100px;width: 100px">
                    <select name="r_module" id="r_module" lay-verify="required" lay-search="">
                        <option value="" selected>请选择</option>
                        <c:forEach items="${requestScope.moduleList}" var="module">
                            <option value="${module.m_module}">${module.m_module}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <br/>
            <br/>
            <label><strong>文章内容</strong></label>
            <!-- 添加Markdown的容器 -->
            <div id="editormd">
                <textarea class="editormd-markdown-textarea" name="editormd-markdown-doc"></textarea>
                <textarea class="editormd-html-textarea" name="editormd-html-code"></textarea>
            </div>
            <div class="layui-inline" style="margin-top: 20px;">
                <button type="button" id="publishBtn" class="layui-btn">发布</button>
            </div>
        </form>
    </div>
    <br/>
    <br/>
    <br/>
</div>
</body>
<!-- JQuery的配置 -->
<script src="<%=basePath%>/static/js/jquery-3.3.1.min.js"></script>
<!-- 加载Layui的配置 -->
<script src="<%=basePath%>/static/layui/layui.all.js"></script>
<!-- Markdown富文本 -->
<script src="<%=basePath%>/static/editormd/editormd.min.js"></script>
<script type="text/javascript">
    <!-- 初始化layui -->
    layui.use('element', function () {
        var element = layui.element;
    });
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        laydate.render({
            elem: '#r_date'
        });
    });
</script>
<!-- Markdown富文本编辑器 -->
<script type="text/javascript">
    var markdown;
    $(function () {
        markdown = editormd("editormd", {
            width: '100%',
            height: '80%',
            syncScrolling: 'single',
            path: '<%=basePath%>/static/editormd/lib/',
            saveHTMLToTextarea: true
        });
    });
</script>

<!--javascript ajax 补充jquery知识-->
<script type="text/javascript">
    // 如果点击了发布按钮
    $("#publishBtn").click(function () {
        var r_id = $("#r_id").val();
        var r_author = $("#r_author").val();
        var r_summary = $("#r_summary").val();
        var r_module = $("#r_module").val();
        var r_content = markdown.getMarkdown();
        var r_date = $("#r_date").val();
        var r_status = 2;
        $.ajax({
            url: '<%=basePath%>/userArticle/insertArticle.do',
            type: 'POST',
            data: {
                r_id: r_id,
                r_author: r_author,
                r_summary: r_summary,
                r_module: r_module,
                r_content: r_content,
                r_date: r_date,
                r_status: r_status
            },
            success: function (data) {
                $("body").html(data);
            },
            error: function () {
                alert("错误");
            }
        });
    });

</script>

</html>
