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

<a href="input2.jsp" target="_top">
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

    <div id="lt2"><!-- ここは左メニューです -->
    <iframe seamless src="volume2.jsp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>
    </div> <!-- id="lt2" ここまで左メニューです -->

</div>
<div id="main"><!-- ########## ここから本文です ########## -->
<div id="main2"><!-- 縁を 20px あけるためのものです -->


<a href="input.jsp">Sheet</a><br>


<!-- item template -->
<script type="text/x-template" id="item-template">
  <li>
    <div
      :class="{bold: isFolder}"
      @click="toggle">
      {{ item.name }}
      <span v-if="isFolder">[{{ isOpen ? '-' : '+' }}]</span>
    </div>
    <ul v-show="isOpen" v-if="isFolder">
      <tree-item
        class="item"
        v-for="(child, index) in item.children"
        :key="index"
        :item="child"
        @make-folder="$emit('make-folder', $event)"
        @add-item="$emit('add-item', $event)"
      >
      </tree-item>
    </ul>
  </li>
</script>

<p>Music Tree...</p>

<!-- the demo root element -->
<ul id="demo">
  <tree-item
    class="item"
    :item="treeData"
    @make-folder="makeFolder"
    @add-item="addItem"
  ></tree-item>
</ul>


<script type="module">

function get_treeData() {
var tsv = getCsv();

  var obj = {'name': '/', 'children':[]};

  var lines = tsv.split('\n').forEach( function( line ) {
    var preobj = obj;
    var cols = line.split('\t');
    var paths = cols[0].substring(1).split('/');
    paths.forEach( function( path ) {
      //console.log( path );
      if (path == paths[paths.length-1]) {
        preobj['children'].push ( {'name': path, 'fullpath': cols[0] , 'title': cols[3] });
      } else {
        var flg = false;
        //console.log( '1)Pre is : ' + preobj['name'] );
        preobj['children'].forEach( function( wk ) {
          //console.log( '1)Wk is : ' + wk['name'] );
          //console.log( '1)path is : ' + path );
          if (wk['name'] == path) {
            preobj = wk;
            flg = true;
            //console.log( 'Get : ' + path );
            //break;
          }
        })
        if (!flg) {
          var newobj = {'name': path, 'children':[]};
          //console.log( '2)Pre is : ' + preobj['name'] );
          //console.log( 'Push : ' + path );
          preobj['children'].push(newobj);
          preobj = newobj;
        }
      }
    })
  })
  console.log(JSON.stringify(obj['children'][0]));

  return obj['children'][0];
};

// demo data
var treeData = get_treeData()

function submitForm(title, filename, oops, id) {
  if (decodeURIComponent(filename) == "-") {
    return false;
  }
  //alert(filename);
  var http = new XMLHttpRequest();
  http.open("POST", "kettei.jsp", true);
  http.setRequestHeader("Content-type","application/x-www-form-urlencoded");
  var params = "filename=" + filename + "&effect=" + oops  + "&title=" + title;
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
}

function getCsv() {
  var request = new XMLHttpRequest();
  request.open('GET', '../all.csv', false);  // `false` で同期リクエストになる
  request.send(null);

  if (request.status === 200) {
    return request.responseText;
  } else {
    return '';
  }
}

// define the tree-item component
Vue.component('tree-item', {
  template: '#item-template',
  props: {
    item: Object
  },
  data: function () {
    return {
      isOpen: false
    }
  },
  computed: {
    isFolder: function () {
      return this.item.children &&
        this.item.children.length
    }
  },
  methods: {
    toggle: function () {
      if (this.isFolder) {
        this.isOpen = !this.isOpen
      } else {
        //alert(this.item.fullpath + '\n' + this.item.title);
        submitForm(this.item.title, encodeURIComponent(this.item.fullpath), '' , '');
      }
    },

  }
})

// boot up the demo
var demo = new Vue({
  el: '#demo',
  data: {
    treeData: treeData
  },
  methods: {
    makeFolder: function (item) {
      Vue.set(item, 'children', [])
      this.addItem(item)
    },
    addItem: function (item) {
      item.children.push({
        name: 'new stuff'
      })
    },


  }
})

</script>



  </body>
</html>
