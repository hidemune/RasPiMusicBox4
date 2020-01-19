<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.lang.*,java.io.*,java.util.*,java.text.*,java.nio.file.*,java.net.*" 

%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="bootstrap.min.css"></script>
    <link rel="stylesheet" href="jcard.css"></script>
    <script src="vue.js"></script>
    <script src="vue-tables-2.min.js"></script>
    <script src="jquery.min.js"></script>
    <title>ミュージックボックス</title>
</head>

<body>


<div id="header"><!-- ここはヘッダです -->

<a href="input.jsp" target="_top">
<%
  //write
  FileWriter objFwS=new FileWriter(application.getRealPath("start"));
  BufferedWriter objBwS=new BufferedWriter(objFwS);
  objBwS.write("1");
  objBwS.close();

  int idx = 1;
  File fileN = new File(application.getRealPath("nowplay"));
  if (fileN.exists()) {
    BufferedReader objBr = new BufferedReader(new InputStreamReader(new FileInputStream(fileN),"UTF-8"));
    String line = "";
    while((line = objBr.readLine()) != null){
      out.println((idx) + ":" + line + "<br>");
      idx++;
      break;
    }
    objBr.close();
  }

  File dir = new File(application.getRealPath("."));
  File[] files = dir.listFiles();
  if (files != null) {
    Arrays.sort(files);
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      //out.println(file.toString());
      //out.println("<br>");
      if (file.toString().startsWith(application.getRealPath("./que"))) {
        if (file.exists()) {
          BufferedReader objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
          String line = "";
          int ln = 0;
          while((line = objBr.readLine()) != null){
            if (ln == 3) {
              out.println((idx) + ":" + line + "<br>");
              idx++;
              break;
            }
            ln = ln + 1;
          }
          objBr.close();
        }
      }
    }
  } else {
    out.println("Empty...");
  }
%>
</a>

<%
  request.setCharacterEncoding("UTF-8");

  String volume = request.getParameter("volume");
  if (volume != null) {
    //write
    FileWriter objFw=new FileWriter(application.getRealPath("volume"));
    BufferedWriter objBw=new BufferedWriter(objFw);
    objBw.write(volume);
    objBw.close();
  }
  String strTxt0 = request.getParameter("textfield0");
  if (strTxt0 == null) {
    strTxt0 = "\t";
  }
  String strTxt1 = request.getParameter("textfield1");
  if (strTxt1 == null) {
    strTxt1 = "\t";
  }
  String strTxt2 = request.getParameter("textfield2");
  if (strTxt2 == null) {
    strTxt2 = "\t";
  }
  if ((strTxt0 + strTxt1 + strTxt2).equals("\t\t\t")) {
    strTxt0 = "\n";
  }
  //out.println("入力：" + strTxt0 + "：" + strTxt1 + "：" + strTxt2 + "：検索します<br>");
  //保存
  String add0 = strTxt0;
  String add1 = strTxt1;
  String add2 = strTxt2;

    String[] rrk = new String[20];
    File file=new File(application.getRealPath("rireki"));
    BufferedReader objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));

    String line = "";
    int i = 0;
    while((line = objBr.readLine()) != null){
      if ((!(line.equals(add0))) && (!(line.equals(add1))) && (!(line.equals(add2)))) {
        if ("".equals(line.trim())) {
          //OK
        }else{
          rrk[i] = line;
          i++;
          if (i == 19) {
            break;
          }
        }
      }
    }
    objBr.close();
    //write
    file=new File(application.getRealPath("rireki"));
    BufferedWriter objBw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file),"UTF-8"));

    if (add0.trim().equals("")) {
      //no
    }else {
      objBw.write(add0);
      objBw.write("\n");
    }
    if (add1.trim().equals("")) {
      //no
    }else {
      objBw.write(add1);
      objBw.write("\n");
    }
    if (add2.trim().equals("")) {
      //no
    }else {
      objBw.write(add2);
      objBw.write("\n");
    }
    for (int j = 0; j < rrk.length; j++) {
      if (rrk[j] == null) {
        break;
      }
      if ("".equals(rrk[j])) {
        break;
      }
      objBw.write(rrk[j]);
      objBw.write("\n");
    }
    objBw.close();
%>



<!-- %=volume% -->
</div><!-- id="header" ここまでヘッダです -->

<div id="sample">
  <label for="toggle">(^_^)</label>
  <input type="checkbox" id="toggle">

    <div id="lt"><!-- ここは左メニューです -->
    <iframe seamless src="volume.jsp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>
    </div> <!-- id="lt" ここまで左メニューです -->

</div>
<div id="main"><!-- ########## ここから本文です ########## -->
<div id="main2"><!-- 縁を 20px あけるためのものです -->

<a href="input2.jsp">Tree</a><br>

入力： <%=strTxt0%>：<%=strTxt1%>：<%=strTxt2%>：検索します<br>

<!--
<h3 class="vue-title">Search</h3>

<div id="word">
  <v-client-table :columns="columns" :data="data" :options="options">
    <input name="textfield0" type="text" class="textField" id="tField0">
    <select name="select0" class="selectBox" id="selBox0" onChange="getSelect(0);" >
      <option value=""></option>

      <option v-for="item in items">
        {{ item.word }}
      </option>
    </select>
  </v-client-table>
</div>


<script>
  Vue.use(VueTables.ClientTable);

  new Vue({
    el: '#word',
    columns: [
      'title',
      'text',
      'items'
    ],
    data:
[
  {
'title': 'USB',
'text': 'home'
  }
],
'items':  [
    
<%
  file=new File(application.getRealPath("rireki"));
  objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
  line = "";
while((line = objBr.readLine()) != null){
      out.println("{ word: '" + line + "' },");
}
objBr.close();
%>
          ]
  },
    options: {
	    columnsDropdown: true, 
      headings: {
        title: 'Category',
        text: 'Search Word',
        items: 'Select'
      },
      sortable: [
        'title'
      ],
      texts: {
        filterPlaceholder: '検索する'
      }
    }
});

</script>

-->

<form method="GET" action="input.jsp">

<table><tr>
<td>
      USB検索ワード:
</td>
<td>
      <input name="textfield0" type="text" class="textField" id="tField0">
</td>
<td>
      <select name="select0" class="selectBox" id="selBox0" onChange="getSelect(0);" >
      <option value=""></option>
<%
  file=new File(application.getRealPath("rireki"));
  objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
  line = "";
while((line = objBr.readLine()) != null){
      out.println("<option value='" + line + "'>" + line + "</option>");
}
objBr.close();
%>
      </select>
</td>
</tr>
<!-- tr>
<td>
      Youtube検索ワード:
</td><td>
      <input name="textfield1" type="text" class="textField" id="tField1">
</td><td>
      <select name="select1" class="selectBox" id="selBox1" onChange="getSelect(1)">
      <option value=""></option>
<%
file=new File(application.getRealPath("rireki"));
objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
line = "";
while((line = objBr.readLine()) != null){
      out.println("<option value='" + line + "'>" + line + "</option>");
}
objBr.close();
%>
      </select>
</td>
</tr -->
</table>

      <input type="submit" value="検索" />
    </form>
<script type="text/javascript">
function getSelect(unit) {
  //alert($("#selBox" + unit).val());
  document.getElementById("tField" + unit).value = $("#selBox" + unit).val();    
}

function getText(unit) {
  var s = document.getElementById("tField" + unit).value;
  alert(s);
}
</script>
<script>



</script>

<h3 class="vue-title">Result</h3>

<div id="app">
  <v-client-table :columns="columns" :data="data" :options="options" :sort-order="sortOrder">
    <slot slot="url" slot-scope="props">
    <button :id="props.row.id" @click="submitForm(props.row.title,  props.row.url,'','')" style="height: 4em;  background-color: #cccccc; ">Play</button>
    <button :id="props.row.id" @click="getLyric(props.row.title,  props.row.artist)" style="height: 4em;  background-color: #cccccc; ">Lyric</button>
    </slot>
  </v-client-table>
</div>

<script>



Vue.use(VueTables.ClientTable);

new Vue({
  el: "#app",
  data: {
    count: 0,
    str1: "xxx",
    columns: [
      'url',
      'album',
      'title',
    ],
    data: getData(),
    options: {
      groupBy: 'artist',
	    columnsDropdown: true, 
      headings: {
        album: 'アルバム',
        title: 'タイトル',
        url: 'Button',
      },
      sortable: [
        'url', 'album', 'title'
      ],
      texts: {
        filterPlaceholder: '検索する'
      },
      sortOrder: [
        {
        field: 'url',
        direction: 'asc'
        }
      ],
    }
  },
  methods: {
    submitForm: function (title, filename, oops, id) {
      if (decodeURIComponent(filename) == "-") {
        return false;
      }
      //alert(filename);
      var http = new XMLHttpRequest();
      http.open("POST", "kettei.jsp", true);
      http.setRequestHeader("Content-type","application/x-www-form-urlencoded");
      var params = "filename=" + filename + "&effect=" + oops + "&title=" + title ;
      http.send(params);
      http.onload = function() {
        $("#header").html( $("#header").html() + "<a href='input.jsp'>" + title + "</a><br>");
        $("#header").css("background-color", "#00cccc");
        
        setTimeout(function () {
          $("#header").css("background-color", "#daeff5");
          $("#header").delay(100).animate({
            scrollTop: $(document).height()
          }, 1500);
        }, 500);
      }
      return false;
    },
  getLyric:function (artist, song) {
      /*
        //var ev = $("#pop11").get(0).onclick;
        //$("#pop11").get(0).onclick = "";
        
        $('input[name=modalPop]').attr('checked',false);
	    $("#pop11").attr("checked", false);
	    $("#pop12").attr("checked", false);
	    $("#pop13").attr("checked", false);
       var ele = document.getElementsByName("modalPop");
       for(var i=0;i<ele.length;i++)
          ele[i].checked = false;
          
        setTimeout(function() {
        var http = new XMLHttpRequest();
        http.open("POST", "lyric.jsp", true);
        http.setRequestHeader("Content-type","application/x-www-form-urlencoded");
        var params = "artist=" + encodeURIComponent(artist) + "&title=" + encodeURIComponent(song) ;
        http.send(params);
        http.onload = function() {
        	try {
		    k = ("\n---\n");
		    var reta = http.responseText.split(k,2);
		    var tita = reta[0].trim().split("\n",2)
		    if (reta[1].trim() != "" ) {
				        $(".modalTitle").html(tita[0] + "<br>" + tita[1]);
	            	$(".modalMain").html("<pre>\n" + reta[1].replace("&amp;","&") + "\n</pre>");
		    } else {
			    //$(".modalMain").html("<p>歌詞の取得に失敗しました。</p>");
			    var win = window.open("https://search.yahoo.co.jp/search?p=" + encodeURIComponent("歌詞 " + artist + " " + song) + "&ei=UTF-8", '_blank');
			    win.focus();
			    return;
		    }        	
	    } catch (e) {
		    $(".modalTitle").html("<p>Lyric</p>");
		    $(".modalMain").html("<p>歌詞の取得に失敗しました!!</p>");
	    };
	    $("#pop11").attr("checked", true);
	       var ele = document.getElementById("pop11");
          	   ele.checked = true;
        }
        }, 500);
        */
      var win = window.open("https://search.yahoo.co.jp/search?p=" + encodeURIComponent("歌詞 " + artist + " " + song) + "&ei=UTF-8", '_blank');
      win.focus();
    }
  }
});



function getData() {
  return [
 <%
file=new File(application.getRealPath("all.csv"));
objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));

line = "";

int buttonid = 0;

int count = 0;
while((line = objBr.readLine()) != null){
  StringTokenizer objTkn=new StringTokenizer(line,"\n");
  
  while(objTkn.hasMoreTokens()){
    String csvLine = objTkn.nextToken();
    boolean flg = true;
    if (csvLine.toLowerCase().indexOf(strTxt0.toLowerCase()) < 0) {
      flg = false;
    }
    if (flg) {
      String[] cols = csvLine.split("\t", -1);
      out.println("{");
      count = count + 1;
      out.println("'id': 'id_" + count + "',");
      out.println("'artist': '" + cols[1].replace("'", "’") + "',");
      out.println("'album': '" + cols[2].replace("'", "’") + "',");
      out.println("'title': '" + cols[3].replace("'", "’") + "',");
      out.println("'url': '" + URLEncoder.encode(cols[0],"utf-8") + "',");
      out.println("'volume': '" + cols[4] + "'");
      
      buttonid = buttonid + 1;
      
      out.println("    },");
      
    }
  }
}
/*
if (count == 0) {
  out.println("{");
  out.println("'id': 'id_" + count + "',");
  out.println("'artist': '-',");
  out.println("'album': '-',");
  out.println("'title': '-',");
  out.println("'url': '-',");
  out.println("'volume': '-'");

  out.println("    },");
}
*/


if (!(strTxt1.equals(""))) {
  try {
    Process p=Runtime.getRuntime().exec("curl -X POST https://www.youtube.com/results?search_query=" + strTxt1);
    
    BufferedReader reader=new BufferedReader(new InputStreamReader(p.getInputStream()));
    String line2 = reader.readLine();
    count = 0;
    while(line2 != null) {
      //out.println(line2.replace("<","&lt;").replace(">","&gt;"));
      boolean flg = true;
        if (line2.indexOf("/watch?v") < 0) {
          flg = false;
        }
        if (flg) {
          //out.println(line2);
          
          String hrefstr = "";
          String textstr = "";
          String[] cols = line2.split("=|\"|\'|>|<", 0);
          //for (int ii=0;ii<cols.length;ii++) {
          //  out.println(ii+ ":" + cols[ii]);
          //}
          for (int ii=0;ii<cols.length;ii++) {
                if (cols[ii].trim().equals("/a")) {
                  textstr = cols[ii-1];
                  break;
                }
          }
          for (int ii=0;ii<cols.length;ii++) {
                if (cols[ii].trim().equals("/watch?v")) {
                  hrefstr = "https://www.youtube.com" + cols[ii+0] + "=" + cols[ii+1];
                  break;
                }
          }
          if (!(textstr.equals(""))) {  
        out.println("{");
        count = count + 1;
        out.println("'id': 'id_" + count + "',");
        out.println("'artist': '-',");
        out.println("'album': '-',");
        out.println("'title': '" + textstr.replace("'", "’").replace("&#39;", "’") + "',");
        out.println("'url': '" + hrefstr + "'");
        out.println("    },");
          }
        }
          
        
      
        line2 = reader.readLine();
      }
/*
    if (count == 0) {
        out.println("{");
        out.println("'id': 'id_" + count + "',");
        out.println("'artist': '-',");
        out.println("'album': '-',");
        out.println("'title': '-',");
        out.println("'url': '-',");
        out.println("'volume': '-'");
        
        out.println("    },");
    }
*/
    reader.close();
//    p.waitFor();
    
  }catch(Exception e) {
    out.println(e);
  }

}

objBr.close();
 %>
  ];
}

</script>


  </body>
</html>
