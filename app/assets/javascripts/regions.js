

$(function(){
    var editor; // use a global for the submit and return data rendering in the examples
    var entity = 'regions';
    var controller_key = 'region';
    var divIdName = '#datatable_regions';
    
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
                }
            },
            remove: {
                type: 'DELETE',
                url:  ''+entity+'/_id_.json'
            }
        },
        table: divIdName,
        idSrc:  'id',
        fields: [ 
            {
                label: "Name:",
                name: "title"
            }
        ]
    } );
 
    $(divIdName).DataTable( {
        dom: "Bfrtip",
        ajax: {'url': "/"+entity+".json"},
        columns: [
            { data: "title"},
        ],
        select: true,
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    } );
});

