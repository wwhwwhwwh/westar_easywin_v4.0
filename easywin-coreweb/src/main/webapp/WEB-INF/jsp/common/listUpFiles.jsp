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
</head>
<body onload="resizeVoteH('${param.ifreamName}');" style="background-color:#FFFFFF;">
<table class="table table-hover general-table">
	<tr>
		<td width="7%" height="40">
			<h5>序号</h5></td>
		<td height="40">
			<h5>名称</h5></td>
		<td width="20%" height="40">
			<h5>上传时间</h5></td>
		<td width="15%" height="40">
			<h5>上传人</h5></td>
		<td width="10%" height="40" align="center"><h5>操作</h5>
	</td>
	</tr>
	<c:choose>
	 	<c:when test="${not empty pageBean.recordList}">
	 		<c:forEach items="${pageBean.recordList}" var="upFile" varStatus="status">
	 			<tr>
	 				<td height="40">${ status.count}</td>
	 				<td align="left">${ upFile.fileName}</td>
	 				<td>${upFile.recordCreateTime}</td>
	 				<td style="text-align: left;">
		 				<div class="ticket-user pull-left other-user-box">
							<img
								src="/downLoad/userImg/${upFile.comId}/${upFile.userId}?sid=${param.sid}"
								title="${upFile.userName}" class="user-avatar" />
							<i class="user-name">${upFile.userName}</i>
							</div>
	 				</td>
		 			<td height="30" align="center">
			 				<c:choose>
			 					<c:when test="${upFile.fileExt=='doc' || upFile.fileExt=='docx' || upFile.fileExt=='xls' || upFile.fileExt=='xlsx' || upFile.fileExt=='ppt' || upFile.fileExt=='pptx' }">
					 				&nbsp;&nbsp;<a class="fa fa-download" href="javascript:void(0)" onclick="downLoad('${upFile.uuid}','${upFile.fileName}','${param.sid }')" title="下载"></a>
					 				&nbsp;&nbsp;<a class="fa fa-eye" href="javascript:void(0)" onclick="viewOfficePage('${upFile.upfileId}','${upFile.uuid}','${upFile.fileName}','${upFile.fileExt}','${param.sid}','${param.busType}','${param.busId}')" title="预览">
					 				</a>
			 					</c:when>
			 					<c:when test="${upFile.fileExt=='txt' || upFile.fileExt=='pdf'}">
			 						&nbsp;&nbsp;<a class="fa fa-download" href="/downLoad/down/${upFile.uuid}/${upFile.fileName}?sid=${param.sid}" title="下载"></a>
					 				&nbsp;&nbsp;<a class="fa fa-eye" href="javascript:void(0)" onclick="viewOfficePage('${upFile.upfileId}','${upFile.uuid}','${upFile.fileName}','${upFile.fileExt}','${param.sid}','${param.busType}','${param.busId}')" title="预览">
					 				</a>
			 					</c:when>
			 					<c:when test="${upFile.fileExt=='jpg'||upFile.fileExt=='bmp'||upFile.fileExt=='gif'||upFile.fileExt=='jpeg'||upFile.fileExt=='png'}">
			 						&nbsp;&nbsp;<a class="fa fa-download" href="/downLoad/down/${upFile.uuid}/${upFile.fileName}?sid=${param.sid}" title="下载"></a>
			 						&nbsp;&nbsp;<a class="fa fa-eye" href="javascript:void(0)" onclick="showPic('/downLoad/down/${upFile.uuid}/${upFile.fileName}','${param.sid}','${upFile.upfileId}','${param.busType}','${param.busId}')" title="预览"></a>
			 					</c:when>
			 					<c:otherwise>
					 				&nbsp;&nbsp;<a class="fa fa-download" onclick="downLoad('${upFile.uuid}','${upFile.fileName}','${param.sid }')" title="下载"></a>
			 					</c:otherwise>
			 				</c:choose>
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
<tags:pageBar url="/demand/listPagedDemandUpfilePage"></tags:pageBar>
<%--用与测量当前页面的高度 --%>
<jsp:include page="/bottomdiv.jsp"></jsp:include>
</body>
</html>
