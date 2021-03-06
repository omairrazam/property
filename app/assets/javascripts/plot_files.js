var entity = 'plot_files';
var controller_key = 'plot_file';

$(function(){
    var editor; // use a global for the submit and return data rendering in the examples

    editor = new $.fn.dataTable.Editor( {
        ajax: {
            create: {
                url:  '/'+entity,
                'contentType': "application/json",
                'type': 'POST',
                'data': function ( d ) {
                    var data= {};
                    data[controller_key] = d['data'][0];

                    if(data[controller_key]['region_id'] == -1){
                        data[controller_key]['region_id'] = null;
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

                    if(data[controller_key]['region_id'] == -1){
                        data[controller_key]['region_id'] = null;
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
        table: "#datatable_files",
        idSrc:  'id',
        fields: [ {
                label: "Serial#",
                name: "serial_no"
            },
            {
                label: "Category:",
                name: "category_id",
                type: 'select'
            },
            {
                label: "Region:",
                name: "region_id",
                type: 'select'
            }
        ]
    } );
 
    $('#datatable_files').DataTable( {
        dom: "Bfrtip",
        ajax: {'url': "/"+entity+".json"},
       "bJQueryUI": true,
        columns: [
            { data: "serial_no" },
            { data: "category.fullname"},
            { data: "region.title"},
            { data: "state"}
        ],
        select: true,
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    } );
});

