<%@page language="java" import="java.util.*" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true"
	errorPage="/WEB-INF/jsp/error/pageException.jsp"%>
<%@page import="com.westar.base.cons.SystemStrConstant"%><%@page import="com.westar.core.web.InitServlet"%>
<%@taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@taglib prefix="fn" uri="/WEB-INF/tld/fn.tld"%>
<%@taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<!DOCTYPE html >
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="renderer" content="webkit">
		<!-- 框架样式 -->
		<jsp:include page="/WEB-INF/jsp/include/static_assets.jsp"></jsp:include>
		<jsp:include page="/WEB-INF/jsp/include/static.jsp"></jsp:include>
		<jsp:include page="/WEB-INF/jsp/include/showNotification.jsp"></jsp:include>
		
		<title><%=SystemStrConstant.TITLE_NAME%></title>
		<script type="text/javascript">
		var showTabIndex = 0;
		$(document).ready(function() {
		    //初始化分享设置
		    if(!strIsNull($("#leaderJson").val())){
				var users = eval("("+$("#leaderJson").val()+")");
				  var img="";
					for (var i=0, l=users.length; i<l; i++) {
						//数据保持
						$("#listUserInfo_id").append('<option selected="selected" value='+users[i].userID+'>'+users[i].userName+'</option>');
						//参与人显示构建
						img = img + "<div class=\"online-list  margin-right-5 margin-bottom-5\" style=\"float:left\" id=\"user_img_listUserInfo_id_"+users[i].userID+"\" >";
						img = img + "<img src=\"/downLoad/userImg/${userInfo.comId}/"+users[i].userID+"?sid=${param.sid}\" class=\"user-avatar\"/>"
						img = img + "<span class=\"user-name\">"+users[i].userName+"</span>"
						img = img + "</div>"
					}
					$("#userLeader_div").html(img);
			}
		    
		    $("#userLearChooseBtn").on("click",function(){
		    	userOne("none", "none", "", '${param.sid}',function(options){
					 var userIds =new Array();
					 var leaders = "";
					 if(options.length>0){
						 $.each(options,function(i,vo){
							 userIds.push($(vo).val());
						 })
					 }
					$("#leaderTempDiv").html(leaders);
					if(!strIsNull(userIds.toString())){
						$.post("/userInfo/updateImmediateSuper?sid=${param.sid}",{Action:"post",userIds:userIds.toString()},     
							function (msgObjs){
							if(msgObjs.succ){
								//ajax获取用户信息
								  $.post("/userInfo/selectedUsersInfo?sid=${param.sid}", { Action: "post", userIds:userIds.toString()},     
										  function (users){
									  var img="";
									  for (var i=0, l=users.length; i<l; i++) {
										//参与人显示构建
											img = img + "<div class=\"online-list margin-left-5 margin-bottom-5\" " +
											"style=\"float:left;cursor:pointer;\" id=\"user_img_listWeekViewer_userId_"+users[i].id+"\">";
											img = img + "<img src=\"/downLoad/userImg/"+users[i].comId+"/"+users[i].id+"?sid=${param.sid}\" " +
											"class=\"user-avatar\"/>"
											img = img + "<span class=\"user-name\">"+users[i].userName+"</span>"
											img = img + "</div>"
										
									  }
									  $("#userLeader_div").html(img);
										showNotification(1,msgObjs.promptMsg);
								  }, "json");
								
							}else{
								showNotification(2,msgObjs.promptMsg);
							}
						},"json");
					}else{
						showNotification(2,"上级设定不能为空");
					}
						
					});
		    })
		    
		    $("#weekViewerSetBtn").on("click",function(){
		    	userMore('listWeekViewer_userId','','${param.sid}','','foreInUser_div',function(result){
		    		 var weekViewers =new Array();
		    		 if(result.length>0){
						  for ( var i = 0; i < result.length; i++) {
							  var obj = {"viewerId":result[i].value,"viewerName":result[i].text}
							  weekViewers.push(obj);
						  }
		    		 }
		    		 $.ajax({
						   type: "POST",
						   dataType: "json",
						   url: "/weekReport/updateWeekViewers?sid=${param.sid}",
						   data: {"weekViewerStr":JSON.stringify(weekViewers)},
						   success: function(data){
				    			 	if(data.status=='f'){
				    			 		showNotification(2,data.info);
				    			 	}else{
				    			 		var listWeekViewer = data.listWeekViewer;
				    			 		$("#listWeekViewer_userId").html("");
				    			 		$("#foreInUser_div").find(".online-list").remove();
				    			 		if(listWeekViewer && listWeekViewer.length>0){
				    			 			$.each(listWeekViewer,function(i,obj){
				    			 				var option = $('<option selected="selected" value="'+obj.viewerId+'">'+obj.viewerName+'</option>');
				    			 				$("#listWeekViewer_userId").append(option);
				    			 				//头像名称父div
				    			 				var divP = $('<div class="online-list" style="float:left" id="user_img_listWeekViewer_userId_'+obj.viewerId+'" ondblclick="removeClickUser(\'listWeekViewer_userId\','+obj.viewerId+')" title="双击移除"></div>');
				    			 				//头像
				    			 				var img = $('<img src="/downLoad/userImg/'+obj.comId+'/'+obj.viewerId+'" class="user-avatar">');
				    			 				//名称
				    			 				var name = $('<span class="user-name">'+obj.viewerName+'</span>')
											
				    			 				$(divP).append(img);
				    			 				$(divP).append(name);
				    			 				
				    			 				$("#weekViewerSetBtn").before($(divP))
				    			 			})
				    			 		}
				    			 		showNotification(1,"设置成功！");
				    			 	}
						   }
						});
		    	});
		    });
		 });

		/* 清除下拉框中选择的option */
		function removeClickUser(id,selectedUserId) {
			var option = $("#listWeekViewer_userId").find("option[value='"+selectedUserId+"']")[0];
			var weekViewer = {"viewerId":option.value,"viewerName":option.text};
			 $.ajax({
				   type: "POST",
				   dataType: "json",
				   url: "/weekReport/delWeekViewer?sid=${param.sid}",
				   data: weekViewer,
				   success: function(data){
	    			 	if(data.status=='f'){
	    			 		showNotification(2,data.info);
	    			 	}else{
	    			 		$("#user_img_listWeekViewer_userId_"+selectedUserId).remove();
	    			 		$(option).remove();
	    			 		selected(id);
	    			 		showNotification(1,"删除成功！");
	    			 	}
				   }
				});
		}
		
		</script>
	</head>
	<body >
	
		<div class="container no-padding" style="width: 100%">	
			<div class="row" >
				<div class="col-lg-12 col-sm-12 col-xs-12" >
					<div class="widget" style="border-bottom: 0px">
			        	<div class="widget-header bordered-bottom bordered-themeprimary detailHead">
			             	<span class="widget-caption themeprimary ps-layerTitle">直属上级设定</span>
		                    <div class="widget-buttons">
								<a href="javascript:void(0)" id="titleCloseBtn" title="关闭">
									<i class="fa fa-times themeprimary"></i>
								</a>
							</div>
			             </div>
						<div id="contentBody" class="widget-body margin-top-40" style="overflow-y:auto;position: relative;">
						
						
						<div class="container" style="padding: 0px 0px;width: 100%">	
				        	<div class="widget" style="margin-top: 0px;" >
				        		<div class="widget-body no-shadow no-padding padding-top-5">
				                	<div class="widget-main ">
				                    	<div class="tabbable">
				                            <div class="tabs-flat">
				                            
				                            	<div class="tab-pane" id="userDepDiv" style="height: 350px">
					                            	<div class="widget-header bg-bluegray no-shadow">
														<span class="widget-caption blue">直属上级</span>
													</div>
													<div class="widget-body no-shadow">
														<div style="width: 250px;display:none;">
															 <select list="listUserInfo" listkey="id" listvalue="userName" id="listUserInfo_id" name="listUserInfo.id" ondblclick="removeClick(this.id)" multiple="multiple" moreselect="true" style="width: 100%; height: 100px;">
															 </select>
														</div>
														
														<div id="userLeader_div" class="pull-left" style="max-width:300px;height: 40px">
														</div>
															<a href="javascript:void(0);" class="btn btn-primary btn-xs margin-left-5" 
															title="单选" id="userLearChooseBtn" style="float: left;">
																<i class="fa fa-plus"></i>选择
															</a> 
														<input type="hidden" id="leaderJson" name="leaderJson" value="${leaderJson}"/>&nbsp;
														<div class="ps-clear"></div>
													</div>
													
												</div>
				                            </div>
				                        </div>
				                    </div>
				                </div>
				        	</div>
				        </div>
						
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>

