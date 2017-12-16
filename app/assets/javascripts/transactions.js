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
            label: "Amount:",
            name: "total_amount",
            attr:{
                type: "number"
            }
        },
        {
            label: "File:",
            name: "plot_file_id",
            type: 'select'
        },
        {
            label: "Mode",
            name: "mode",
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
        }


        ]

    } );
    $(divIdName).DataTable( {
        dom: "Bfrtip",
        ajax: {
            'url': "/"+entity+".json"
        },
        columns: [
        {
            data: "total_amount"
        },

        {
            data: "plot_file.serial_no"
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
            data: "target_date"
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

