<%@page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" errorPage="/WEB-INF/jsp/error/pageException.jsp"%>
<%@page import="com.westar.base.cons.SystemStrConstant"%><%@page import="com.westar.core.web.InitServlet"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@taglib prefix="fn" uri="/WEB-INF/tld/fn.tld"%>
<%@taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="renderer" content="webkit">
    <title><%=SystemStrConstant.TITLE_NAME %></title>
    <jsp:include page="/WEB-INF/jsp/include/static_bootstrap.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/jsp/include/static.jsp"></jsp:include>
    <script type="text/javascript">
	//删除分享附件
	function delDailyFile(ts,dailyId,dailyUpFileId,type){
		window.top.layer.confirm("确定删除附件?", {icon: 3, title:'确认对话框'}, function(index){
			window.top.layer.close(index);
			$.post("/daily/delDailyUpfile?sid=${param.sid}",{Action:"post",dailyId:dailyId,dailyUpFileId:dailyUpFileId,type:type},     
					function (data){
					if(data.status=='y'){
						showNotification(1,"操作成功");
						$(ts).parents("tr").remove();
						$.each($(".fileOrder"),function(index,item){
							$(this).html(index+1)
						})
					}else{
						showNotification(2,data.info);
						
					}
			},"json");
		});
		
	}
</script>
</head>
<body onload="resizeVoteH('otherIframe');initCard('${param.sid}')" style="background-color:#FFFFFF;">
<table class="table table-hover general-table">
    <tr>
        <td width="8%" height="40">
            <h5>序号</h5></td>
        <td height="40">
            <h5>名称</h5></td>
        <td width="25%" height="40">
            <h5>上传时间</h5></td>
        <td width="18%" height="40">
            <h5>上传人</h5></td>
        <td width="14%" height="40" align="center"><h5>操作</h5></td>
    </tr>
    <c:choose>
        <c:when test="${not empty dailyFiles}">
            <c:forEach items="${dailyFiles}" var="dailyFile" varStatus="status">
                <tr>
                    <td height="40">${ status.count}</td>
                    <td align="left"><tags:cutString num="45">${ dailyFile.fileName}</tags:cutString></td>
                    <td>${dailyFile.upTime}</td>
                    <td style="text-align: left;">
                        <div class="ticket-user pull-left other-user-box" data-container="body" data-toggle="popover" data-placement="left"
                             data-user='${dailyFile.userId}' data-busId='${dailyFile.dailyId}' data-busType='006'>
                             <img src="/downLoad/userImg/${dailyFile.comId}/${dailyFile.userId}?sid=${param.sid}"
                                     title="${dailyFile.username}" class="user-avatar" />
                            <i class="user-name">${dailyFile.username}</i>
                        </div>
                    </td>
                    <td height="30" align="center">
                        <c:choose>
                            <c:when test="${dailyFile.fileExt=='doc' || dailyFile.fileExt=='docx' || dailyFile.fileExt=='xls' || dailyFile.fileExt=='xlsx' || dailyFile.fileExt=='ppt' || dailyFile.fileExt=='pptx'}">
                                &nbsp;&nbsp;<a class="fa fa-download" href="javascript:void(0)" onclick="downLoad('${dailyFile.fileUuid}','${dailyFile.fileName}','${param.sid }')" title="下载"></a>
                                &nbsp;&nbsp;<a class="fa fa-eye" href="javascript:void(0)" onclick="viewOfficePage('${dailyFile.upfileId}','${dailyFile.fileUuid}','${dailyFile.fileName}','${dailyFile.fileExt}','${param.sid}','006','${dailyId}')" title="预览">
                                </a>
                            </c:when>
                            <c:when test="${dailyFile.fileExt=='txt' || dailyFile.fileExt=='pdf' }">
                                &nbsp;&nbsp;<a class="fa fa-download"  href="/downLoad/down/${dailyFile.fileUuid}/${dailyFile.fileName}?sid=${param.sid}" title="下载"></a>
                                &nbsp;&nbsp;<a class="fa fa-eye" href="javascript:void(0)" onclick="viewOfficePage('${dailyFile.upfileId}','${dailyFile.fileUuid}','${dailyFile.fileName}','${dailyFile.fileExt}','${param.sid}','006','${dailyId}')" title="预览">
                                </a>
                            </c:when>
                            <c:when test="${dailyFile.fileExt=='jpg'||dailyFile.fileExt=='bmp'||dailyFile.fileExt=='gif'||dailyFile.fileExt=='jpeg'||dailyFile.fileExt=='png'}">
                                &nbsp;&nbsp;<a class="fa fa-download"  href="/downLoad/down/${dailyFile.fileUuid}/${dailyFile.fileName}?sid=${param.sid}" title="下载"></a>
                                &nbsp;&nbsp;<a class="fa fa-eye" href="javascript:void(0)" onclick="showPic('/downLoad/down/${dailyFile.fileUuid}/${dailyFile.fileName}','${param.sid}','${dailyFile.upfileId}','006','${dailyId}')" title="预览"></a>
                            </c:when>
                            <c:otherwise>
                                &nbsp;&nbsp;<a class="fa fa-download"  onclick="downLoad('${dailyFile.fileUuid}','${dailyFile.fileName}','${param.sid }')" title="下载"></a>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${empty delete && dailyFile.userId==userInfo.id}">
				 			<a style="margin-left:5px;" class="fa  fa-times-circle fa-lg" href="javascript:void(0);" title="删除" onclick="delDailyFile(this,${dailyFile.dailyId},${dailyFile.id},'${dailyFile.type}')"></a>
		 				</c:if>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td height="25" colspan="7" align="center"><h3>没有相关信息！</h3></td>
            </tr>
        </c:otherwise>
    </c:choose>
</table>
<tags:pageBar url="daily/dailyFilePage"></tags:pageBar>

<%--用与测量当前页面的高度 --%>
<jsp:include page="/bottomdiv.jsp"></jsp:include>
</body>
</html>
