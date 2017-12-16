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
            label: "Buyer:",
            name: "buyer_id",
            type: 'select'
        },
        {
            label: "Seller:",
            name: "seller_id",
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

    $(divIdName).DataTable( {
        dom: "Bfrtip",
        ajax: {
            'url': "/"+entity+".json"
        },
        columns: [
        {
            data: "category.fullname"
        },
        {
            data: "region.title"
        },
        {
            data: "seller.username"
        },
        {
            data: "buyer.username"
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
            data: 'mode'
        },
        {
            data: "target_date"
        },
        {
            data: "created_at"
        }

        ],
        select: true,
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
        }
        ]
    } );
});

