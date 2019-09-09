
jQuery(function($){
    var editor; // use a global for the submit and return data rendering in the examples
    var entity = 'installments';
    var controller_key = 'installment';
    var divIdName = '#datatable_installments';
    
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
                name: "amount"
            },
            {
                label: "File:",
                name: "plot_file_id",
                type: 'select'
            }
        ]
    } );
 
    $(divIdName).DataTable( {
        dom: "Bfrtip",
        ajax: {'url': "/"+entity+".json"},
        columns: [
            { data: "amount"},
            { data: "plot_file.serial_no"}
        ],
        select: true,
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    } );
});

