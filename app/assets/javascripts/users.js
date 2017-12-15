

$(function(){
    var editor; // use a global for the submit and return data rendering in the examples

    var entity = 'users';
    var controller_key = 'user';
    var divIdName = '#datatable_users';

    editor = new $.fn.dataTable.Editor( {
        ajax: {
            create: {
                url:  '/'+entity,
                'contentType': "application/json",
                'type': 'POST',
                'data': function ( d ) {
                    var data = {user: d['data'][0]};
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
                    var data = {user: d.data[i]};
                    return data;
                },
            },
            remove: {
                type: 'DELETE',
                url:  entity+'/_id_.json'
            }
        },
        table: divIdName,
        idSrc:  'id',
        fields: [ {
                label: "User Name:",
                name: "username"
            },
            {
                label: "Email:",
                name: "email",
            },
            {
                label: "Password:",
                name: "password",
                type: "password"
            },
            {
                label: "password confirmation:",
                name: "password_confirmation",
                type: "password"
            },
            {
                label: "CNIC:",
                name: "cnic"
            },
            {
                label: "Phone:",
                name: "phone"
            },
            {
                label: "Address:",
                name: "address"
            }
        ]
    } );
$.fn.dataTable.ext.errMode = 'throw';
    $(divIdName).DataTable( {
        dom: "Bfrtip",
        ajax: {'url': "/"+entity+".json", "dataSrc":''},
        "bJQueryUI": true,
        columns: [
            { data: "username" },
            { data: "email" },

        ],
        select: true,
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    } );
});

