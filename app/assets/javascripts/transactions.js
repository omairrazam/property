$(function(){
    // Add event listener for opening and closing details
    

    var editor; // use a global for the submit and return data rendering in the examples
    var entity = 'transactions';
    var controller_key = 'transaction';
    var divIdName = '#datatable_transactions';
    
    

    editor = new $.fn.dataTable.Editor({
        template: '#customForm',
        table: divIdName,
        ajax: {
            create: {
                url:  '/'+entity,
                'contentType': "application/json",
                'type': 'POST',
                'data': function ( d ) {
                    var data= {};
                    data[controller_key] = d['data'][0];

                    if(data[controller_key]['category_id'] == -1){
                        data[controller_key]['category_id'] = null;
                    }

                    return JSON.stringify( data );
                },
                error: datatableAjaxError
            },
            edit: {
                type: 'PUT',
                url:  '/'+entity+'/_id_.json',
                'data': function ( d ) {
                    var id;
                   
                    for (var i in d.data) {
                        id = i;
                    }

                    var data={};
                    data[controller_key] = d['data'][i];

                    if(data[controller_key]['category_id'] == -1){
                        data[controller_key]['category_id'] = null;
                    }

                    return data;
                },
                error: datatableAjaxError
            },
            remove: {
                type: 'DELETE',
                url:  ''+entity+'/_id_.json',
                error: datatableAjaxError
            }
        },
        table: divIdName,
        idSrc:  'id',
        fields: [
        {
            label: "Category:",
            name: "category_id",
            type: 'select'
        }, 
        {
            label: "Region:",
            name: "region_id",
            type: 'select'
        }, 
        {
            label: "Pieces:",
            name: "duplicate_count",
            attr:{
                type: "number"
            }
        },
        {
            label: "TotalAmount:",
            name: "total_amount",
            attr:{
                type: "number"
            }
        },
        {
            label: "Received Amount:",
            name: "recieved_amount",
            attr:{
                type: "number"
            }
        },
        {
            label: "Nature",
            name: "nature",
            type: "select"
        },
        {
            label: "C/O:",
            name: "care_of_id",
            type: 'select'
        },
        {
            label: "Trader:",
            name: "trader_id",
            type: 'select'
        },
        {
            label: "Mode:",
            name: "mode",
            type: "select"
        },
        {
            label: "Extension Days:",
            name: "target_date_in_days",
            attr:{
                type: "number"
            }
        }
        
        ]

    } );

$( editor.field( 'mode' ).node() ).on('change', function () {
    var mode = editor.field( 'mode' ).val();
    
    if(mode == 'bop' || mode == 'sop'){
        editor.field('target_date_in_days').show();
    }else{
        editor.field('target_date_in_days').hide();
    }

});


var table = $(divIdName).DataTable( {
      dom: "Bfrtip",
      ajax: {
          'url': "/"+entity+".json"
      },

      order: [[ 10, "desc" ]],
      "columns": [
        { "data": "duplicate_count" },
        { "data": "category.fullname",
           render:function (value) {
            var nt = value;
            return  nt[0].toUpperCase() + nt.slice(1);
           } 
        },
        { "data": "region.title",
           render:function (value) {
            var nt = value;
            return  nt[0].toUpperCase() + nt.slice(1);
           } 
        },
        { "data": "care_of.username",
           render:function (value) {
            var nt = value;
            return  nt[0].toUpperCase() + nt.slice(1);
           } 
        },
        { "data": "trader.username",
           render:function (value) {
            var nt = value;
            return  nt[0].toUpperCase() + nt.slice(1);
           } 
        },
        { "data": "total_amount",
          render: function(data,type,row){
            return  (row.total_amount * row.duplicate_count);
          }
        },
        { "data": "recieved_amount",
          render: function(data,type,row){
            return  (row.recieved_amount * row.duplicate_count);
          }
        },
        { "data": "remaining_amount" ,
          render: function(data,type,row){
            return  (row.remaining_amount * row.duplicate_count);
          }
        },
        { "data": "nature",
           render:function (value) {
            var nt = value;
            return  nt[0].toUpperCase() + nt.slice(1);
           } 
        },
        { "data": "mode",
           render:function (value) {
            var nt = value;
            return  nt[0].toUpperCase() + nt.slice(1);
           }  
        },
        { "data": "transaction_date",
           "type": 'datetime',
           render:function (value) {
            var dt = new Date(value);
            return dt.toLocaleDateString();
          } 
        },
        { "data": "target_date",
           "type": 'datetime',
           render:function (value) {
            var dt = new Date(value);
            return dt.toLocaleDateString();
          } 
        },
        
    ],
      lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
      select:true,
      buttons: [
          {
              extend: "create",
              editor: editor
          },
          {
              extend: "edit",
              editor: editor
          },
          {
              extend: "remove",
              editor: editor
          },
          {
              extend: 'collection',
              text: 'Export',
              buttons: [
                  'copy',
                  'excel',
                  'csv',
                  'pdf',
                  'print'
              ]
          }
      ]
  });
});

// function child_data( d ) {
//     // `d` is the original data object for the row
//      var tableStr = '<table class="display dataTable no-footer" cellspacing="0" width="100%">';
//       for (var key in d["children"]) {
//         for (var i=0; i<key.length; i++) {
//            var date = d["children"][key]["created_at"].slice(0, 10).split('-');
//            var t_date = d["children"][key]["target_date"].slice(0, 10).split('-');
//            var single_amount = Math.round(d["children"][key]["total_amount"] / d["children"][key]["duplicate_count"]);
//            tableStr += '<tr>' +
//            '<td></td>' +
//            '<td >'+ d["children"][key]["category_id"] + '</td>' +
//            '<td>' + d["children"][key]["region_id"] + '</td>' +
//            '<td>' + d["children"][key]["care_of_id"] + '</td>' +
//            '<td>' + d["children"][key]["trader_id"] + '</td>' +
//            '<td>' + single_amount + '</td>' +
//            '<td>' + d["children"][key]["recieved_amount"] + '</td>' +
//            '<td>' + d["children"][key]["recieved_amount"] + '</td>' +
//            '<td>' + d["children"][key]["nature"] + '</td>' +
//            // '<td>' + d["children"][key]["mode"] + '</td>' +
//            '<td>' + d["children"][key]["mode"] + '</td>' +
//            '<td>' + t_date[1] +'/'+ date[2] +'/'+ date[0] + '</td>' +
//            '<td>' + date[1] +'/'+ date[2] +'/'+ date[0] + '</td>' +
//            '</tr>';
//         }
//       }

//   return tableStr + '</table>';
// }

