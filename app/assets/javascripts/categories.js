

$(function(){
    var editor; // use a global for the submit and return data rendering in the examples

    var entity = 'categories';
    var controller_key = 'category';
    var divIdName = '#datatable_categories';

    editor = new $.fn.dataTable.Editor( {
        ajax: {
            create: {
                url:  '/'+entity,
                'contentType': "application/json",
                'type': 'POST',
                'data': function ( d ) {
                    var data = {category: d['data'][0]};
                    if(data.category.unit == -1){
                        data.category.unit = '';
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
                    var data = {category: d.data[i]};
                    if(data.category.unit == -1){
                        data.category.unit = '';
                    }
                    return data;
                },
                error: datatableAjaxError
            },
            remove: {
                type: 'DELETE',
                url:  entity+'/_id_.json',
                error: datatableAjaxError
            }
        },
        table: divIdName,
        idSrc:  'id',
        fields: [ {
                label: "Name",
                name: "name"
            },
            {
                label: "Size:",
                name: "size"
            },
            {
                label: "Unit:",
                name: "unit",
                type: "select",
                def: -1
            }
        ]
    } );

    $(divIdName).DataTable( {
        dom: "Bfrtip",
        ajax: {'url': "/"+entity+".json"},
        "bJQueryUI": true,
        columns: [
            { data: "name" },
            { data: "dim" },
        ],
        select: true,
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    } );
});

