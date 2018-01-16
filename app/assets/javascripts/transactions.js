


jQuery(function($){
    // Add event listener for opening and closing details


    $('#datatable_transactions thead tr:eq(1) th').each( function () {
        var title = $('#datatable_transactions thead tr:eq(0) th').eq( $(this).index() ).text();
        var type = $(this).data('inputtype')
        $(this).html( '<input class="input-table-header" type="text" placeholder="Search '+title+'" />' );
        if(type == 'date'){
          $(this).datepicker({
              format: 'dd/mm/yyyy',
          });
        }
    } ); 
  
    $('body').on('focus','.input-table-header',function(){
      $(this).css('width','95px');
    });

    $('body').on('change','.input-table-header',function(){
      console.log($(this).val());
    });

    $('body').on('blur','.input-table-header',function(){
      $(this).css('width','25px');
    });

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
                data: function(d){
                    return {}
                },
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
            label: "Per Piece Amount:",
            name: "total_amount",
            attr:{
                type: "number"
            }
        },
        {
            label: "Total Received Amount",
            name: "aggregate_recieved",
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
            label: "Transaction Date",
            name: "transaction_date",
            type: "datetime"
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
            label: "Comment:",
            name: "comment",
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
      "orderClasses": false,
      orderCellsTop: true,
      responsive: true,
      "createdRow": function ( row, data, index ) {
        if(data["paid"]){
          $('td',row).eq(7).addClass('green');
        }else{
          $('td',row).eq(7).addClass('red');
        }

        if(data["is_new"]){
          $('td',row).eq(0).addClass('pink');

        }
        // if ( data[5].replace(/[\$,]/g, '') * 1 > 150000 ) {
        //     $('td', row).eq(5).addClass('highlight');
        // }
      },

      order: [[ 11, "desc" ]],
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
        { "data": "total_amount"},
        { "data": "total_amount",
          render: function(data,type,row){
            return  (row.total_amount * row.duplicate_count);
          }
        },
        { "data": "aggregate_recieved"
        },
        { "data": "remaining_amount" ,
          render: function(data,type,row){
            return  (row.total_amount * row.duplicate_count) - row.aggregate_recieved;
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
           "type": 'date',
           render:function (value) {
            var dt = new Date(value);
            return dt.toLocaleDateString();
          } 
        },
        { "data": "target_date",
           "type": 'datetime',
           render:function (value) {
            if(!value){
              return '';
            }
            var dt = new Date(value);
            return dt.toLocaleDateString();
          } 
        },
        { "data": "comment" },

        
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
                  'print',

              ]
          },
          {
                text: 'Clear IT',
                action: function ( e, dt, node, config ) {
                    editor
                      .edit( table.row( { selected: true } ).index(), false )
                      .set( 'aggregate_recieved', editor.get('total_amount' )*editor.get('duplicate_count'))
                      .submit();

                },
                enabled: false
          },
          {
            text: 'Add Person',
            action: function ( e, dt, node, config ) {
              Rails.fire($('#new_person_link')[0], 'click');
            }
          }
      ],

      "footerCallback": function ( row, data, start, end, display ) {
            var api = this.api(), data;
 
            // Remove the formatting to get integer data for summation
            var intVal = function ( i ) {
                return typeof i === 'string' ?
                    i.replace(/[\$,]/g, '')*1 :
                    typeof i === 'number' ?
                        i : 0;
            };
 
            // Total over all pages
            total = api
                .column( 6 )
                .data()
                .reduce( function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0 );
 
            // Total over this page
            totAmount = api
                .column( 6, { page: 'current'} )
                .data()
                .reduce( function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0 );

            recAmount = api
                .column( 7, { page: 'current'} )
                .data()
                .reduce( function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0 );
            remAmount = api
                .column( 8, { page: 'current'} )
                .data()
                .reduce( function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0 );
 
            // Update footer
            $( api.column( 6 ).footer() ).html(
                'Rs:'+totAmount
            );
            $( api.column( 7 ).footer() ).html(
                'Rs:'+recAmount 
            );
            $( api.column( 8 ).footer() ).html(
                'Rs:'+remAmount
            );
        }

  });

   // Apply the search
    table.columns().every(function (index) {
        $('#datatable_transactions thead tr:eq(1) th:eq(' + index + ') input').on('keyup change', function () {
            table.column($(this).parent().index() + ':visible')
                .search(this.value)
                .draw();
        });
    });

    table.on( 'select deselect', function () {
        var selectedRows = table.rows( { selected: true } ).count();
        table.button( 4 ).enable( selectedRows === 1 );
    } );

    editor
    .on( 'postSubmit', function ( e, json, data, action ) {
        //table.ajax.reload();
        location.reload();
    } )
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

