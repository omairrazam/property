$(function(){
    var editor; // use a global for the submit and return data rendering in the examples
    var entity = 'transactions';
    var controller_key = 'transaction';
    var divIdName = '#datatable_transactions';
    
    editor = new $.fn.dataTable.Editor( {
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
        columns: [
        {
            data: "category.fullname"
        },
        {
            data: "region.title"
        },
        {
            data: "care_of.username"
        },
        {
            data: "trader.username"
        },
        {
            data: "total_amount"
        },

        {
            data: "recieved_amount"
        },

        {
            data: "remaining_amount"
        },
        {
            data: 'nature'
        },
        {
            data: 'mode',
            render: function(value){
                return value;
            }
        },
        {
            data: "target_date",
            type: "datetime",
            render:function (value) {
                var dt = new Date(value);
                return dt.toLocaleDateString();
            }
        },
        {
            data: "created_at",
            type: 'datetime',
            render:function (value) {
                var dt = new Date(value);
                return dt.toLocaleDateString();
            }
        }

        ],
        select: true,
        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
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
    } );
});

