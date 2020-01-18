<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.io.*,java.util.*,java.text.*,java.nio.file.*" %>

<!DOCTYPE html>
<html lang="ja">
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <link rel="stylesheet" type="text/css" href="jcard.css" />
 <meta http-equiv="Pragma" content="no-cache">
 <meta http-equiv="Cache-Control" content="no-cache">
 <meta http-equiv="Expires" content="0">
<title>ミュージックボックス</title>
</head>

<body id="iframe">
<script src="jquery.min.js"></script>
<script>
function nextMusic() {
    var http = new XMLHttpRequest();
    http.open("POST", "kettei.jsp", true);
    http.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    var params = "cancel=1" ;
    http.send(params);
    http.onload = function() {
        //alert(http.responseText);
        $("#iframe").css("background-color", "#00cccc");
        
        setTimeout(function () {
          $("#iframe").css("background-color", "#daeff5");
        }, 500);
    }
}
</script>
<br>
<br>
<br>

<button type="button" name="cancel" value="1" onClick='nextMusic()'"><font size="5" color="#333399">&nbsp;次の曲&nbsp;&nbsp;</font>
</button>

<br>
<br>

<!-- a href="volume.jsp?stop=1">
<button type="button" name="stop" value="1"><font size="5" color="#333399">&nbsp;&nbsp;再生終了&nbsp;&nbsp;</font>
</button>
<%
  request.setCharacterEncoding("UTF-8");

  String stop = request.getParameter("stop");
  //write
  if (stop != null) {
    FileWriter objFw=new FileWriter(application.getRealPath("stop"));
    BufferedWriter objBw=new BufferedWriter(objFw);
    objBw.write("1\n");
    objBw.close();
  }
%>
-->

<br>
<br>
<label>音量</label><br>

<%
    String vol = "";
    FileReader objFr=new FileReader(application.getRealPath("volume"));
    BufferedReader objBr=new BufferedReader(objFr);
    String line = "";
    while((line = objBr.readLine()) != null){
      vol = line;
    }
    objBr.close();

  for(int i=100;i >= 60;i = i - 5){
    String num = "    " + i;
    num = num.substring(num.length()-4,num.length()).replace(" ","&nbsp;");
%>

<a href="input.jsp?volume=<%=i%>" target="_top">
<button type="button" name="volume" value="<%=i%>">
<font size="5" color="#333399"><%=num%></font>
</button>
<%
  if (vol.equals("" + i)) {
    out.println("★");
  }
%>
</a>
<br>

<%
  }
%>

<br>
<br>



<br>
</body>
</html>


