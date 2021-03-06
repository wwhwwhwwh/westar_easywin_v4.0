<%@page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" errorPage="/WEB-INF/jsp/error/pageException.jsp"%>
<%@page import="com.westar.base.cons.SystemStrConstant"%><%@page import="com.westar.core.web.InitServlet"%>
<%@page import="com.westar.base.model.BiaoQing"%>
<%@page import="com.westar.core.web.BiaoQingContext"%>
<%@page import="com.westar.core.web.TokenManager"%>
<%@page import="com.westar.base.util.DateTimeUtil"%>
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
<jsp:include page="/WEB-INF/jsp/include/showNotification.jsp"></jsp:include>
<script type="text/javascript" src="/static/js/autoTextarea.js?version=<%=InitServlet.SYSTEM_STARUP_TIME%>"></script>
<script> 
$(function(){
	//初始化名片
	$(".txtScheTalk").autoTextarea({minHeight:55,maxHeight:160});  
	$(".txtScheTalk").bind("paste cut keydown keyup focus blur",function(event){
		resizeVoteH('otherScheIframe')
    });
	
	//信息推送
	$("body").on("click","a[data-todoUser]",function(){
		var relateDiv = $(this).attr("data-relateDiv");
		var params = {};
		//查询所有
		params.onlySubState = 0;
		userMore('null',params , '${param.sid}',"null","null",function(options){
			if(options && options[0]){
				$.each(options,function(index,option){
					var span = $('<span></span>');
					var userId = option.value;
					//去重
					var preUserSpan = $("#"+relateDiv).find("span[data-userId='"+userId+"']");
					if(preUserSpan && preUserSpan.get(0)){
						return true;
					}
					$(span).attr("data-userId",option.value);
					$(span).attr("title","双击移除");
					$(span).addClass("blue");
					$(span).css("cursor","pointer");
					$(span).css("padding-right","5px");
					$(span).html('@'+option.text);
					
					var userObj = {}
					userObj.userId = option.value;
					userObj.userName = option.text;
					$(span).data("userObj",userObj);
					
					$("#"+relateDiv).append($(span));
				})
			}else{
				$("#"+relateDiv).html("");
			}
		})
	})
	
	//信息推送移除
	$("body").on("dblclick","span[data-userId]",function(){
		$(this).remove();
	})
	
	
	
	
})
//窗体点击事件检测
document.onclick = function(e){
	   var evt = e?e:window.event;
	   var ele = evt.srcElement || evt.target;
	   //表情包失焦关闭
		for(var i=0;i<biaoQingObjs.length;i++){
			if(ele.id != biaoQingObjs[i].switchID){
				$("#"+biaoQingObjs[i].divID).hide();
			}
		}
}
//创建一个表情对象数组
var biaoQingObjs = new Array();
//初始化最新初始化表情对象
var activingBiaoQing;
//表情对象添加；switchID触发器开关，objID返回对象主键,表情显示div层主键
function addBiaoQingObj(switchID,divID,objID){
	//数组是否已经包含此元素标识符
	var haven = false;
	//判断数组是否已经包含此主键元素
	if(isBiaoQingEvent(switchID)){
		haven = true;
	}
	//对象构建
	var biaoQing ={"switchID":switchID,"objID":objID,"divID":divID}
	if(!haven){
		//主键存入数组
		biaoQingObjs[biaoQingObjs.length]=biaoQing;
	}
	//初始化最新初始化表情对象
	activingBiaoQing = biaoQing;
	//打开表情
	biaoQingOpen(biaoQing);
}
//判断页面点击事件事都是表情触发事件
function isBiaoQingEvent(eventId){
	//数组是否已经包含此元素标识符
	var haven = false;
	//判断数组是否已经包含此主键元素
	for(var i=0;i<biaoQingObjs.length;i++){
		if(biaoQingObjs[i].switchID==eventId){
			haven = true;
			break;
		}
	}
	return haven;
}
//表情打开
function biaoQingOpen(obj){
	$("#"+obj.divID).show();
}
//表情包关闭
function biaoQingClose(){
	$("#"+activingBiaoQing.divID).hide();
}
//关闭表情div，并赋值
function divClose(title,path){
	biaoQingClose();
	insertAtCursor(activingBiaoQing.objID,title)
	$("#"+activingBiaoQing.objID).focus();
}
//样式设置
function setStyle(){
	$(".txtScheTalk").autoTextarea({minHeight:55,maxHeight:160});  
}
/**
 * busId 业务主键
 * busType 业务类型
 * talkPId 回复的父节点
 * ts 当前节点
 */
function addTalk(scheduleId,talkPId,ts){
	var textarea = $("#operaterReplyTextarea_"+talkPId);
	var content = $(textarea).val();
	if(""==content){
		layer.tips("请填写内容",$(textarea),{tips:1});
		$(textarea).focus();
		return;
	}else{
		var params = {"scheduleId":scheduleId,
		        "parentId":talkPId,
		        "talkContent":content};
		var relateTodoDiv = $("#"+$(ts).attr("data-relateTodoDiv"));
		if(relateTodoDiv && relateTodoDiv.get(0)){
			var todoUsers = $(relateTodoDiv).find("span");
			if(todoUsers && todoUsers.get(0)){
				$.each(todoUsers,function(index,user){
					var user = $(this).data("userObj")
					params["listScheUsers["+index+"].userId"] = user.userId;
					params["listScheUsers["+index+"].userName"] = user.userName;
				})
			}
		}
		var onclick = $(ts).attr("onclick");
		//异步提交表单 投票讨论
	    $("#fileForm").ajaxSubmit({
	        type:"post",
	        url:"/schedule/addScheTalk?sid=${param.sid}&t="+Math.random(),
	        beforeSubmit:function(a,o,f){
		        $(ts).removeAttr("onclick");
		    },
	        data:params,
	        dataType: "json", 
	        success:function(data){
	        	var scheTalk = data.scheTalk;
			    var html = getScheTalkStr(scheTalk,'${param.sid}',data.sessionUser);
			    $(textarea).val('');
			    if(talkPId==-1){
		       		$("#alltalks").prepend(html);
		       	}else{
		       		//父节点
			     	$("#delScheTalk_"+talkPId).attr("onclick","delScheTalk("+talkPId+",0)")
		       		$("#talk"+talkPId).after(html);
			     	$("#addTalk"+talkPId).hide();
			     	$("#img_"+talkPId).attr("class","fa fa-comment-o");
		       	}
			    $(relateTodoDiv).html("");
			    setStyle();
			   $(ts).attr("onclick",onclick);
			   resizeVoteH('otherScheIframe');
	        },
	        error:function(XmlHttpRequest,textStatus,errorThrown){
	        	showNotification(2,"操作失败")
				$(textarea).html('');
			    $(ts).attr("onclick",onclick);
	        }
	    });
	}
}

function getScheTalkStr(scheTalk,sid,sessionUser){
	var html = '';
	if(scheTalk.parentId==-1){
		html+='\n<div id="talk'+scheTalk.id+'" class="ws-shareBox scheTalkInfoP">';
	}else{
		html+='\n<div id="talk'+scheTalk.id+'" class="ws-shareBox ws-shareBox2 scheTalkInfoP">';
	}
	html+='\n		<div class="shareHead" data-container="body">';
	//头像信息
	html += '		<img src="/downLoad/userImg/'+scheTalk.comId+'/'+scheTalk.talker+'?sid='+sid+'" title="'+scheTalk.talkerName+'"></img>\n';
	html+='\n 		</div>';
	
	html+='\n		<div class="shareText">';
	html+='\n			<span class="ws-blue">'+scheTalk.talkerName+'</span>';
	if(scheTalk.parentId>-1){
		html+='\n		<r>回复</r>';
		html+='\n		<span class="ws-blue">'+scheTalk.ptalkerName+'</span>';
	}
	html+='\n			<p class="ws-texts">'+scheTalk.talkContent+'</p>';
	html+='\n			<div class="ws-type">';
	//发言人可以删除自己的发言
	html+='\n				<span class="hideOpt">';
	html+='\n 					<a href="javascript:void(0)" id="delScheTalk_'+scheTalk.id+'" onclick="delScheTalk('+scheTalk.id+',1)" class="fa fa-trash-o" title="删除" style="margin-right: 5px"></a>';
	html+='\n 					<a href="javascript:void(0)" id="img_'+scheTalk.id+'" onclick="showArea(\'addTalk'+scheTalk.id+'\')" class="fa fa-comment-o" title="回复" style="margin-right: 5px"></a>';
	html+='\n				</span>';
	if(scheTalk.parentId>-1){
	html+='\n				<br>';
	}
	html+='\n				<span>';
	html+='\n 					<time>'+scheTalk.recordCreateTime+'</time>';
	html+='\n				</span>';
	html+='\n			</div>';
	html+='\n		</div>';
	html+='\n		<div class="ws-clear"></div>';
	html+='\n	</div>';
	//回复层
	html+='\n 	<div id="addTalk'+scheTalk.id+'" style="display:none;" class="ws-shareBox ws-shareBox2 ws-shareBox3 addTalk">';
	html+='\n 		<div class="shareText">';
	html+='\n 			<div class="ws-textareaBox" style="margin-top:10px;">';
	html+='\n 				<textarea id="operaterReplyTextarea_'+scheTalk.id+'" name="operaterReplyTextarea_'+scheTalk.id+'" style="height: 55px" class="form-control txtScheTalk" placeholder="回复……"></textarea>';
	html+='\n				<div class="ws-otherBox" style="position: relative;">';
	
	//表情
	html+='\n					<div class="ws-meh">';
	html+='\n 						<a href="javascript:void(0);" class="fa fa-meh-o tigger" id="biaoQingSwitch_'+scheTalk.id+'" onclick="addBiaoQingObj(\'biaoQingSwitch_'+scheTalk.id+'\',\'biaoQingDiv_'+scheTalk.id+'\',\'operaterReplyTextarea_'+scheTalk.id+'\');"></a>';
	html+= '\n				     	<div id="biaoQingDiv_'+scheTalk.id+'" class="blk" style="display:none;position:absolute;width:200px;top:30px;z-index:99;left: 15px">';
	html+= '\n				     		<div class="main">';
	html+= '\n				           		<ul style="padding: 0px">';
	html+= ' \n'+getBiaoqing();
	html+= '\n				           		</ul>';
	html+= '\n				       	 	</div>';
	html+= '\n				     	</div>';
	html+= '\n				  	</div>';
	//常用意见 
	html+='\n 					<div class="ws-plugs">';
	html+='\n 						<a href="javascript:void(0);" class="fa fa-comments-o" onclick="addIdea(\'operaterReplyTextarea_'+scheTalk.id+'\',\''+sid+'\');" title="常用意见"></a>';
	html+= '\n				 	 </div>';
	//@
	html+='\n 					<div class="ws-plugs">';
	html+='\n 						<a class="btn-icon" href="javascript:void(0)" title="学习人员" data-todoUser="yes" data-relateDiv="todoUserDiv_'+scheTalk.id+'">@</a>';
	html+= '\n				 	 </div>';
	
	//分享按钮
	html+='\n					<div class="ws-share">';
	html+='\n						<button type="button" class="btn btn-info ws-btnBlue" onclick="addTalk(${scheduleId},'+scheTalk.id+',this)" data-relateTodoDiv="todoUserDiv_'+scheTalk.id+'">回复</button>';
	html+='\n					</div>';
	html+='\n					<div style="clear: both;"></div>';
	
	html+='\n					<div id="todoUserDiv_'+scheTalk.id+'" class="padding-top-10">';
	html+='\n					</div>';
	
	
	html+='\n				</div>';
	html+='\n			</div>';
	html+='\n		</div>';
	html+='\n	</div>';
	return html;
}
//删除评论
function delScheTalk(id,isLeaf,ts){
	window.top.layer.confirm("确定要删除该回复吗?",{title:"询问框",icon:3},function(index){
		window.top.layer.close(index);
		if(isLeaf==1){
			//异步提交表单删除评论
		    $("#fileForm").ajaxSubmit({
		        type:"post",
		        url:"/schedule/delScheTalk?sid=${param.sid}&t="+Math.random(),
		        data:{"id":id},
		        dataType: "json",
		        success:function(data){
		        	window.self.location.reload();
		        },
		        error:function(XmlHttpRequest,textStatus,errorThrown){
		        	showNotification(2,"操作失败");
		        }
		    });
		}else{
			window.top.layer.confirm("是否需要删除此节点下的回复信息?",{title:"询问框",icon:3,btn:['是','否']},function(index){
				//异步提交表单删除评论
			    $("#fileForm").ajaxSubmit({
			        type:"post",
			        url:"/schedule/delScheTalk?sid=${param.sid}&t="+Math.random(),
			        data:{"id":id,"delChildNode":"yes"},
			        dataType: "json", 
			        success:function(data){
			        	window.self.location.reload();
			        },
			        error:function(XmlHttpRequest,textStatus,errorThrown){
			        	showNotification(2,"操作失败");
			        }
			    });
			    window.top.layer.close(index);
			},function(index){
				//异步提交表单删除评论
			    $("#fileForm").ajaxSubmit({//删除自己
			        type:"post",
			        url:"/schedule/delScheTalk?sid=${param.sid}&t="+Math.random(),
			        data:{"id":id,"delChildNode":"no"},
			        dataType: "json", 
			        success:function(data){
			        	window.self.location.reload();
			        },
			        error:function(XmlHttpRequest,textStatus,errorThrown){
			        	showNotification(2,"操作失败");
			        }
			    });
			    window.top.layer.close(index);
			});
		}
	});	
}
/**
 * 显示回复的回复
 */
function showArea(priId){
	var addtalks = $(".addTalk");
	$(".fa-comment").attr("title","回复");
	$(".fa-comment").attr("class","fa fa-comment-o");
	for(var i=0;i<addtalks.length;i++){
		var talkId = $(addtalks[i]).attr("id");
		var imgId = "img_"+talkId.replace("addTalk","");
		if(talkId==priId){
			 if($("#"+priId).css('display')=="none"){
		     	$("#"+imgId).attr("title","隐藏");
		     	$("#"+imgId).attr("class","fa fa-comment");
			 	$("#"+priId).show();
		     }else{
		     	$("#"+priId).hide();
		     	$("#"+imgId).attr("title","回复");
		     	$("#"+imgId).attr("class","fa fa-comment-o");
		     }
		}else{
			$("#"+talkId).hide();
	     	$("#"+imgId).attr("title","回复");
	     	$("#"+imgId).attr("class","fa fa-comment-o");
		}
	}
	 resizeVoteH('otherScheIframe')
}
</script>
</head>
<body style="background-color: #fff"  onload="setStyle();resizeVoteH('otherScheIframe');">
<form id="fileForm" class="subform">
	<%--当前操作员的回复 --%>
	<div class="parentRep">
	
		<div class="ws-textareaBox" style="margin-top:10px;">
			<textarea id="operaterReplyTextarea_-1" style="height: 55px" class="form-control txtScheTalk" placeholder="请输入内容……"></textarea>
			<div class="ws-otherBox" style="position: relative;">
				<div class="ws-meh">
					<%--表情 --%>
					<a href="javascript:void(0);" class="fa fa-meh-o tigger" id="biaoQingSwitch" onclick="addBiaoQingObj('biaoQingSwitch','biaoQingDiv','operaterReplyTextarea_-1');"></a>
					<div id="biaoQingDiv" class="blk" style="display:none;position:absolute;width:200px;top:30px;z-index:99;left: 15px">
					<!--表情DIV层-->
			        <div class="main">
			            <ul style="padding: 0px">
			            <jsp:include page="/biaoqing.jsp"></jsp:include>
			            </ul>
			        </div>
								    </div>
				</div>
				<%--常用意见 --%>
				<div class="ws-plugs">
					<a href="javascript:void(0);" class="fa fa-comments-o" onclick="addIdea('operaterReplyTextarea_-1','${param.sid}');" title="常用意见"></a>
				</div>
				<div class="ws-plugs">
				    <a class="btn-icon" href="javascript:void(0)" title="告知人员"
				    data-todoUser="yes" data-relateDiv="todoUserDiv_-1">
				    	@
					</a>
				</div>
				
				<div class="ws-share">
					<button type="button" class="btn btn-info ws-btnBlue" onclick="addTalk('${scheduleId}',-1,this)" data-relateTodoDiv="todoUserDiv_-1">发表</button>
				</div>
				<div style="clear: both;"></div>
				<div id="todoUserDiv_-1" class="padding-top-10">
	             			
	            </div>
			</div>
		</div>
		<div class="ws-border-line" style="height: 1px"></div>
	</div>
	<%--当前讨论结束 --%>
	<%--列出有回复内容 --%>
	<div id="alltalks" style="clear:both">
		<c:if test="${not empty scheTalks}">
			<c:forEach items="${scheTalks}" var="scheTalk" varStatus="vs">
				<div id="talk${scheTalk.id}" class="ws-shareBox ${scheTalk.parentId==-1?'':'ws-shareBox2'} scheTalkInfo${scheTalk.parentId==-1?'P':''}">
					<div class="shareHead" data-container="body">
						<%--头像信息 --%>
						<img src="/downLoad/userImg/${scheTalk.comId}/${scheTalk.talker}?sid=${param.sid}" title="${scheTalk.talkerName}"></img>
					</div>
					<div class="shareText">
						<span class="ws-blue">${scheTalk.talkerName}</span>
						<c:if test="${scheTalk.parentId>-1}">
							<r>回复</r>
							<span class="ws-blue">${scheTalk.ptalkerName}</span>
						</c:if>
						<p class="ws-texts">
							${scheTalk.talkContent}
						</p>
						<div class="ws-type" >
							<span class="hideOpt">
								<%--发言人可以删除自己的发言 --%>
								<c:if test="${sessionUser.id==scheTalk.userId}">
									<a href="javascript:void(0);" id="delScheTalk_${scheTalk.id}" onclick="delScheTalk(${scheTalk.id},${scheTalk.isLeaf},this)" class="fa fa-trash-o" title="删除" style="margin-right: 5px"></a>
								</c:if>
								<a id="img_${scheTalk.id}" name="replyImg" onclick="showArea('addTalk${scheTalk.id}')" href="javascript:void(0);" class="fa fa-comment-o" title="回复" style="margin-right: 5px"></a>
							</span>
							<c:if test="${scheTalk.parentId>-1}">
							<br>
							</c:if>
							<span>
								<time>${scheTalk.recordCreateTime}</time>
							</span>
						</div>
					</div>
					<div class="ws-clear"></div>
				</div>
				<!-- 回复层 -->
				<div id="addTalk${scheTalk.id}" style="display:none;" class="ws-shareBox ws-shareBox2 ws-shareBox3 addTalk">
					<div class="shareText">
						<div class="ws-textareaBox" style="margin-top:10px;">
							<textarea id="operaterReplyTextarea_${scheTalk.id}" name="operaterReplyTextarea_${scheTalk.id}" style="height: 55px" rows="" cols="" class="form-control txtScheTalk" placeholder="回复……"></textarea>
							<div class="ws-otherBox" style="position: relative;">
								
									<div class="ws-meh" style="position: relative;">
											<%--表情 --%>
											<a href="javascript:void(0);" class="fa fa-meh-o tigger" id="biaoQingSwitch_${scheTalk.id}" onclick="addBiaoQingObj('biaoQingSwitch_${scheTalk.id}','biaoQingDiv_${scheTalk.id}','operaterReplyTextarea_${scheTalk.id}');"></a>
											<div id="biaoQingDiv_${scheTalk.id}" class="blk" style="display:none;position:absolute;width:200px;top:0px;z-index:99;left: 20px">
												<!--表情DIV层-->
										        <div class="main">
										            <ul style="padding: 0px">
										            <jsp:include page="/biaoqing.jsp"></jsp:include>
										            </ul>
										        </div>
										    </div>
										</div>
										<%--常用意见 --%>
										<div class="ws-plugs">
											<a href="javascript:void(0);" class="fa fa-comments-o" onclick="addIdea('operaterReplyTextarea_${scheTalk.id}','${param.sid}');" title="常用意见"></a>
										</div>
										<div class="ws-plugs">
										    <a class="btn-icon" href="javascript:void(0)" title="告知人员"
										    	data-todoUser="yes" data-relateDiv="todoUserDiv_${scheTalk.id}">
										    	@
											</a>
										</div>
								
								<%--分享按钮 --%>
								<div class="ws-share">
									<button type="button" class="btn btn-info ws-btnBlue" onclick="addTalk('${scheduleId}',${scheTalk.id},this)" data-relateTodoDiv="todoUserDiv_${scheTalk.id}">回复</button>
								</div>
								<%--相关附件 --%>
								<div style="clear: both;"></div>
								<div id="todoUserDiv_${scheTalk.id}" class="padding-top-10">
	             			
	           		 			</div>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
		</c:if>
	</div>
	<tags:pageBar url="/schedule/listScheTalks"></tags:pageBar>
</form>
<div style="margin-bottom: 140px"></div>
<%--用与测量当前页面的高度 --%>
<jsp:include page="/bottomdiv.jsp"></jsp:include>
</body>
</html>
