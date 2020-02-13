<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.io.*,java.util.*,java.text.*" %>

<html>
  <head>
    <meta http-equiv="refresh" content="1;URL=input.jsp">
    <title>ミュージックボックス</title>
  </head>
  <body>
<%
  //次の曲（Volume.jspより）
  request.setCharacterEncoding("UTF-8");

  String cancel = request.getParameter("cancel");
  //write
  if (cancel != null) {
    FileWriter objFwC=new FileWriter(application.getRealPath("cancel"));
    BufferedWriter objBwC=new BufferedWriter(objFwC);
    objBwC.write("1\n");
    objBwC.close();
    objFwC.close();
  }

  request.setCharacterEncoding("UTF-8");

  String strTxt = request.getParameter("filename");
  String volume = request.getParameter("volume");
  String effect = request.getParameter("effect");
  String title = request.getParameter("title");
  String artist = request.getParameter("artist");
  if (strTxt != null) {
    //strTxt = "'" + strTxt + "'";
    out.println("入力：" + strTxt + " / vol:" + volume + "：予約します");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");

    File file = new File(application.getRealPath("que" + sdf.format(Calendar.getInstance().getTime())));
    file.setWritable(true);

    BufferedWriter objBw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file),"UTF-8"));
    objBw.write(strTxt);
    objBw.write("\n");

    if (volume != null) {
      //write
      objBw.write(volume);
      objBw.write("\n");
    } else {
      objBw.write("70");
      objBw.write("\n");
    }

    if (effect != null) {
      //write
      objBw.write(effect);
      objBw.write("\n");
    } else {
      objBw.write("");
      objBw.write("\n");
    }

    if (title != null) {
      //write
      objBw.write(title);
      objBw.write("\n");
    } else {
      objBw.write("");
      objBw.write("\n");
    }

    if (artist != null) {
      //write
      objBw.write(artist);
      objBw.write("\n");
    } else {
      objBw.write("");
      objBw.write("\n");
    }

    objBw.close();
  }
 %>
    <br>
    <br>
    <a href="input.jsp">予約システムに移動</a>
  </body>
</html>
