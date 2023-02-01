<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title></title>

    <!-- Bootstrap -->
    <link href="../css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/bootstrap-table.css" rel="stylesheet">
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap-table.js"></script>
    <script src="../bootstrap-table-zh-CN.js"></script>
    <link rel="stylesheet" href="../public/layui/css/layui.css" media="all">
    <style>
        .layui-table, .layui-table-view {
            margin: 0 0px;
        }

        .layui-form-select dl dd.layui-this {
            background-color: #01AAED;
        }
    </style>

</head>
<body>
<jsp:useBean id="msg" scope="session" class="javabean.JDBCBean"></jsp:useBean>
<script src="../public/layui/layui.js" charset="utf-8"></script>
<!-- 表单 -->
<table class="layui-hide" id="cardTable" lay-filter="formFilter"></table>

<!-- 头部工具栏 -->
<%--	<script type="text/html" id="headBar">--%>
<%-- 		 条件搜索：--%>
<%--		<div class="layui-inline">--%>
<%--	  	  <select id="condition" name="condition" lay-verify="required">--%>
<%--        	<option value=""></option>--%>
<%--			<option value="id">图书编号</option>--%>
<%--			<option value="name">图书名称</option>--%>
<%--        	<option value="author">作者</option>--%>
<%--			<option value="position">位置</option>--%>
<%--			<option value="description">描述</option>--%>
<%--		  </select>--%>
<%--	 	 </div>--%>
<%--  		<div class="layui-inline">--%>

<%--    		<input class="layui-input" id="conditionValue" name="conditionValue" id="demoReload" autocomplete="off">--%>
<%--  		</div>--%>
<%--  		<button class="layui-btn layui-bg-blue" name="condition" data-type="reload"  lay-event="search">搜索</button>--%>
<%--	</script>--%>


<script>
    layui.use(['table', 'jquery'], function () {
        $ = layui.jquery;
        var table = layui.table;
        // 进行渲染
        var tableIns = table.render({
            elem: '#cardTable'
            , url: './device'
            , toolbar: '#headBar'
            , cols: [[
                {field: 'id', width: 120, title: '设备编号', sort: true}
                , {field: 'name', width: 130, title: '设备名称', sort: true}
                , {field: 'mark', width: 100, title: '设备标签', sort: true}
                , {field: 'ip', title: 'IP地址', width: 120, sort: true}
                , {field: 'username', width: 100, title: '用户名', sort: true,}
                , {field: 'password', width: 100, title: '密码', sort: true}
                , {
                    field: 'onlinestatus', width: 100, title: '在线状态', sort: true, templet: function (item) {
                        var btns = "";
                        if (item.onlinestatus == '0') {
                            btns += '<span class=""style="color:red">离线</span>';
                        } else if (item.onlinestatus == '1') {
                            btns += '<span class=""style="color:green">在线</span>';
                        }
                        return btns;
                    }
                }
                , {
                    field: 'occupystatus', width: 100, title: '占用状态', sort: true, templet: function (item) {
                        var btns = "";
                        if (item.occupystatus == '1') {
                            btns += '<span class=""style="color:#ff0000">已占用</span>';
                        } else if (item.occupystatus == '0') {
                            btns += '<span class=""style="color:green">未占用</span>';
                        }
                        return btns;
                    }
                }
                , {field: 'notes', minWidth: 80, title: '备注'}

            ]]
            , page: true
            , page: {theme: '#2F88FF'},
        });

        // 头部工具栏事件
        // table.on('toolbar(formFilter)', function (obj) {
        //     var checkStatus = table.checkStatus(obj.config.id);
        //     switch (obj.event) {
        //         // 条件查找图书证
        //         case 'search':
        //             var conditionValue = $('#conditionValue');
        //             var condition = $('#condition');
        //
        //             // 进行搜索，重新渲染
        //             tableIns.reload({
        //                 where: { //设定异步数据接口的额外参数，任意设
        //                     "condition": condition.val(),
        //                     "conditionValue": conditionValue.val()
        //                 }
        //                 , page: {
        //                     curr: 1 //重新从第 1 页开始
        //                 }
        //             });
        //             break;
        //
        //         case 'add':
        //             var addCardLayer = layer.open({
        //                 type: 2,
        //                 title: '添加借书证',
        //                 area: ['800px', '500px'],
        //                 maxmin: true,
        //                 shadeClose: true,
        //                 content: 'cardadd.jsp',
        //             });
        //         //layer.full(addCardLayer);
        //     }
        //
        // });

        // 侧边工具栏事件
        table.on(('tool(formFilter)'), function (obj) {
            var data = obj.data;
            var layEvent = obj.event;
            var tr = obj.tr;
            switch (obj.event) {
                case 'edit':
                    layer.open({
                        type: 2,
                        title: '更改信息',
                        area: ['800px', '600px'],
                        maxmin: true,
                        shadeClose: true,
                        content: '',
                    })
                    break;
            }
        })
    });
</script>
</body>
</html>