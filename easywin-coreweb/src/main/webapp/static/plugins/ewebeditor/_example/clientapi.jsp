<%@ page contentType="text/html;charset=GBK" pageEncoding="GBK"%>

<HTML>
<HEAD>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7">
<TITLE>eWebEditor �� �ͻ���APIʾ��</TITLE>
<META http-equiv=Content-Type content="text/html; charset=GBK">
<link rel='stylesheet' type='text/css' href='example.css'>
</HEAD>
<BODY>

<p><b>���� �� <a href="default.jsp">ʾ����ҳ</a> &gt; �ͻ���APIʾ��</b></p>
<p>��������eWebEditor�ṩ�Ŀͻ���API���Ա༭��ִ�и߼�����������API����μ������ֲᡣ</p>



<FORM method="post" name="myform" action="retrieve.jsp">
<TABLE border="0" cellpadding="2" cellspacing="1">
<TR>
	<TD>�༭���ݣ�</TD>
	<TD>
		<INPUT type="hidden" name="content1" value="&lt;p&gt;eWebEditor - ����HTML�༭����HTML���߱༭�ð���&lt;/p&gt;">
		<IFRAME ID="eWebEditor1" src="../ewebeditor.htm?id=content1&style=coolblue" frameborder="0" scrolling="no" width="550" height="350"></IFRAME>
	</TD>
</TR>
<TR>
	<TD colspan=2 align=right>
	<INPUT type=submit value="�ύ"> 
	<INPUT type=reset value="����"> 
	<INPUT type=button value="�鿴Դ�ļ�" onclick="location.replace('view-source:'+location)"> 
	</TD>
</TR>
<TR>
	<TD>HTML���룺</TD>
	<TD><TEXTAREA cols=50 rows=5 id=myTextArea style="width:550px">�����ȡֵ����ť����һ��Ч����</TEXTAREA></TD>
</TR>
<TR>
	<TD colspan=2 align=right>

<script type="text/javascript">
function DoAPI(s_Flag){
	var o_Editor = document.getElementById("eWebEditor1").contentWindow;
	var o_Text = document.getElementById("myTextArea");
	switch(s_Flag){
	case "gethtml":
		o_Text.value = o_Editor.getHTML();
		break;
	case "gettext":
		o_Text.value = o_Editor.getText();
		break;
	case "sethtml":
		o_Editor.setHTML("<b>Hello My World!</b>");
		break;
	case "inserthtml":
		o_Editor.insertHTML("This is insertHTML function!");
		break;
	case "appendhtml":
		o_Editor.appendHTML("This is appendHTML function!");
		break;
	case "code":
		o_Editor.setMode("CODE");
		break;
	case "edit":
		o_Editor.setMode("EDIT");
		break;
	case "text":
		o_Editor.setMode("TEXT");
		break;
	case "view":
		o_Editor.setMode("VIEW");
		break;
	case "getcount0":
		alert(o_Editor.getCount(0));
		break;
	case "getcount1":
		alert(o_Editor.getCount(1));
		break;
	case "getcount2":
		alert(o_Editor.getCount(2));
		break;
	case "getcount3":
		alert(o_Editor.getCount(3));
		break;
	case "readonly1":
		o_Editor.setReadOnly("1");
		break;
	case "readonly2":
		o_Editor.setReadOnly("2");
		break;
	case "readonly0":
		o_Editor.setReadOnly("");
		break;

	}

}

</script>

		<INPUT type=button value="ȡֵ(HTML)" onclick="DoAPI('gethtml')" class=btn> 
		<INPUT type=button value="ȡֵ(���ı�)" onclick="DoAPI('gettext')" class=btn> 
		<INPUT type=button value="��ֵ" onclick="DoAPI('sethtml')" class=btn>
		<INPUT type=button value="��ǰλ�ò���" onclick="DoAPI('inserthtml')" class=btn>
		<INPUT type=button value="β��׷��" onclick="DoAPI('appendhtml')" class=btn>
		<br>
		<INPUT type=button value="����״̬" onclick="DoAPI('code')" class=btn>
		<INPUT type=button value="���״̬" onclick="DoAPI('edit')" class=btn>
		<INPUT type=button value="�ı�״̬" onclick="DoAPI('text')" class=btn>
		<INPUT type=button value="Ԥ��״̬" onclick="DoAPI('view')" class=btn>
		<br>
		<INPUT type=button value="Ӣ������" onclick="DoAPI('getcount0')" class=btn>
		<INPUT type=button value="��������" onclick="DoAPI('getcount1')" class=btn>
		<INPUT type=button value="��Ӣ������(���ļ�1)" onclick="DoAPI('getcount2')" class=btn>
		<INPUT type=button value="��Ӣ������(���ļ�2)" onclick="DoAPI('getcount3')" class=btn>	
		<br>
		<INPUT type=button value="ֻ��[ģʽ1]" onclick="DoAPI('readonly1')" class=btn>
		<INPUT type=button value="ֻ��[ģʽ2]" onclick="DoAPI('readonly2')" class=btn>
		<INPUT type=button value="ȡ��ֻ��" onclick="DoAPI('readonly0')" class=btn>

	</TD>
</TR>
</TABLE>
</FORM>


</BODY>
</HTML>