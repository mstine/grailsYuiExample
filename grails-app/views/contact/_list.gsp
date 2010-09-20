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
  <link rel="stylesheet" type="text/css" href="${resource(dir: "js/yui-2.8.1/build/assets/skins/sam", file: "calendar.css")}">

  <script src="${resource(dir: "js/yui-2.8.1/build/yahoo-dom-event", file: "yahoo-dom-event.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/element", file: "element-min.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/datasource", file: "datasource-min.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/json", file: "json-min.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/connection", file: "connection-min.js")}" type="text/javascript"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/calendar", file: "calendar-min.js")}"></script>
  <script src="${resource(dir: "js/yui-2.8.1/build/datatable", file: "datatable-min.js")}" type="text/javascript"></script>

  <script type="text/javascript">
    function createAsyncSubmitter(recordId, controller, action, formatter) {
      return function(callback, newValue) {
        var record = this.getRecord();
        var recordIdValue = record.getData(recordId);

        if (formatter != null) {
          newValue = formatter(newValue)
        }

        //TODO: Find a way to make this URL generation automatically include the rootContext rather than hardcoding it
        YAHOO.util.Connect.asyncRequest('GET', '/grailsYuiExample/' + controller + '/' + action + '?id=' + recordIdValue + '&choice=' + newValue,
        {
          success:function(o) {
            var r = YAHOO.lang.JSON.parse(o.responseText);
            if (r.replyCode == 201) {
              callback(true, r.data);
            } else {
              alert(r.replyText);
              callback();
            }
          },
          failure:function(o) {
            alert(o.statusText);
            callback();
          },
          scope:this
        });
      }
    }

    function initChoiceEditorFromRequest(choiceEditor, request) {
      var choiceRequest = YAHOO.util.Connect.asyncRequest('GET', request, {
        success:function(o) {
          try {
            choiceEditor.dropdownOptions = YAHOO.lang.JSON.parse(o.responseText);
            choiceEditor.render();
          } catch (e) {
            alert("Option Data Call failed for" + request + "!");
            return;
          }
        },
        failure:function(o) {
          alert("Option Data Call failed for" + request + "!");
          return;
        },
        scope:this
      });
    }


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
          {key:"notes"},
          {key:"delete"}
        ]
      };

      var contactTypeChoiceEditor = new YAHOO.widget.DropdownCellEditor({
        asyncSubmitter: createAsyncSubmitter('id', 'contact', 'updateType')
      });
      initChoiceEditorFromRequest(contactTypeChoiceEditor, '${createLink(controller:"contactType", action:"choices")}');

      var productChoiceEditor = new YAHOO.widget.DropdownCellEditor({
        asyncSubmitter: createAsyncSubmitter('id', 'contact', 'updateProduct')
      });
      initChoiceEditorFromRequest(productChoiceEditor, '${createLink(controller:"product", action:"choices")}');

      var customerChoiceEditor = new YAHOO.widget.DropdownCellEditor({
        asyncSubmitter: createAsyncSubmitter('id', 'contact', 'updateCustomer')
      });
      initChoiceEditorFromRequest(customerChoiceEditor, '${createLink(controller:"customer", action:"choices")}');

      var myColumnDefs = [
        {key:"id"},
        {key:"customer", label:"Customer", sortable:true, editor: customerChoiceEditor},
        {key:"product", label:"Product", sortable:true, editor: productChoiceEditor},
        {key:"date", label:"Date", sortable:true, formatter:"date", editor: new YAHOO.widget.DateCellEditor({
          asyncSubmitter: createAsyncSubmitter('id', 'contact', 'updateDate', function(newValue) {
            return (newValue.getMonth() + 1) + '/' + newValue.getDate() + '/' + newValue.getFullYear();
          })
        })},
        {key:"type", label:"Type", sortable:true, editor: contactTypeChoiceEditor},
        {key:"notes", label:"Notes", editor: new YAHOO.widget.TextboxCellEditor({
          asyncSubmitter: createAsyncSubmitter('id', 'contact', 'updateNotes')
        })},
        {key:"delete", label:"", formatter:"button"}
      ];

      var myDataTable = new YAHOO.widget.DataTable("datatable", myColumnDefs, myDS);

      var mlsIdCol = myDataTable.getColumn(0);
      myDataTable.hideColumn(mlsIdCol);

      myDataTable.subscribe("cellClickEvent", myDataTable.onEventShowCellEditor);

      myDataTable.subscribe('buttonClickEvent', function(oArgs) {
        var event = oArgs.event,
                target = oArgs.target,
                oRecord = this.getRecord(target);

        YAHOO.util.Connect.asyncRequest('GET', '/grailsYuiExample/contact/remove/' + oRecord.getData('id'),
        {
          success:function(o) {
            var r = YAHOO.lang.JSON.parse(o.responseText);
            if (r.replyCode == 201) {
              myDataTable.deleteRow(myDataTable.getRecordSet().getRecordIndex(oRecord));
            } else {
              alert(r.replyText);
            }
          },
          failure:function(o) {
            alert(o.statusText);
          },
          scope:this
        });
      });

      YAHOO.util.Event.addListener("addRow", "click", function() {
        YAHOO.util.Connect.asyncRequest('GET', '/grailsYuiExample/contact/add/',
        {
          success:function(o) {
            var r = YAHOO.lang.JSON.parse(o.responseText);
            if (r.replyCode == 201) {
              myDataTable.addRow({id:r.data.id, customer:r.data.customer, product:r.data.product, date:new Date(), type:r.data.type, notes:''});
            } else {
              alert(r.replyText);
            }
          },
          failure:function(o) {
            alert(o.statusText);
          },
          scope:this
        });


        return false;
      });
    })
            ;
  </script>
</head>
<body class="yui-skin-sam">
<h1>Contact Manager</h1>
<div id="datatable"></div>
<input id="addRow" type="button" value="Add Contact"/>
</body>
</html>