<%--
  Created by IntelliJ IDEA.
  User: mstine
  Date: Sep 19, 2010
  Time: 10:52:07 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Simple GSP page</title>
  <link type="text/css" rel="stylesheet" href="${resource(dir: "js/yui-2.8.1/build/assets/skins/sam", file: "datatable.css")}">

  <script src="${resource(dir: "js/yui-2.8.1/build/yahoo-dom-event", file: "yahoo-dom-event.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/element", file: "element-min.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/datasource", file: "datasource-min.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/json", file: "json-min.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/connection", file: "connection-min.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/datatable", file: "datatable-min.js")}" type="text/javascript"></script>

  <script type="text/javascript">
    YAHOO.util.Event.addListener(window, "load", function() {

      var myDS = new YAHOO.util.XHRDataSource("${createLink(action: "dataTable")}");
      myDS.responseType = YAHOO.util.XHRDataSource.TYPE_JSON;

      myDS.responseSchema = {
        resultsList: "contacts",
        fields: [
          {key:"id"},
          {key:"customer"},
          {key:"product"},
          {key:"date", parser:"date"},
          {key:"type"},
          {key:"notes"}
        ]
      };

      var myColumnDefs = [
        {key:"id"},
        {key:"customer", label:"Customer", sortable:true},
        {key:"product", label:"Product", sortable:true},
        {key:"date", label:"Date", sortable:true, formatter:"date"},
        {key:"type", label:"Type", sortable:true},
        {key:"notes", label:"Notes"}
      ];

      var myDataTable = new YAHOO.widget.DataTable("datatable", myColumnDefs, myDS);

      var mlsIdCol = myDataTable.getColumn(0);
      myDataTable.hideColumn(mlsIdCol);
    });
  </script>
</head>
<body class="yui-skin-sam">
<h1>Contact Manager</h1>
<div id="datatable"></div>
</body>
</html>