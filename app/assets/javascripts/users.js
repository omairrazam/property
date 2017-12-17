

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

                    if(data[controller_key]['role'] == -1){
                        data[controller_key]['role'] = null;
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
                    var data = {user: d.data[i]};
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
                label: "User Name:",
                name: "username"
            },
            {
                label: "Email:",
                name: "email",
            },
            {
                label: "Role:",
                name: "role",
                type: 'select'
            },
            {
                label: "Password:",
                name: "password",
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


$(divIdName).DataTable({
        dom: "Bfrtip",
        ajax: {'url': "/"+entity+".json"},
        "bJQueryUI": true,
        columns: [
            { data: "username" },
            { data: "email" },
            { data: "role" },
        ],
        select: true,
        buttons: [
            { extend: "create", editor: editor },
            { extend: "edit",   editor: editor },
            { extend: "remove", editor: editor }
        ]
    });
});

