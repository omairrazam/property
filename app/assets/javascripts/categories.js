

$(function(){
    var editor; // use a global for the submit and return data rendering in the examples

    var entity = 'categories';
    var controller_key = 'category';
    var divIdName = '#datatable_categories';

    editor = new $.fn.dataTable.Editor( {
        ajax: {
            create: {
                url:  '/categories',
                'contentType': "application/json",
                'type': 'POST',
                'data': function ( d ) {
                    var data = {category: d['data'][0]};
                    return JSON.stringify( data );
                },

            },
            edit: {
                type: 'PUT',
                url:  '/categories/_id_.json',
                'data': function ( d ) {
                    console.log(d);
                    var id;
                    for (var i in d.data) {
                      id = i;
                    }
                    var data = {category: d.data[i]};
                    return data;
                }
            },
            remove: {
                type: 'DELETE',
                url:  'categories/_id_.json'
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
                name: "unit"
            }
        ]
    } );

    $(divIdName).DataTable( {
        dom: "Bfrtip",
        ajax: {'url': "/categories.json", "dataSrc":''},
        "bJQueryUI": true,
        columns: [
            { data: "name" },
            { data: "size" },
            { data: "unit" },
        ],
        select: true,
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    } );
});

