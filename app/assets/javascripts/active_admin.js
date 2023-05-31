//= require active_admin/base
//= require activeadmin_addons/all
//= require active_material

$(document).ready(function () {

    $('.atlante-adas').on("select2:select", function (e) {
        let $target = $(e.target);
        $.ajax({
            type: "GET",
            url: $target.data('url') + "?ada="+$target.val(),
            success: function (result) {
                let fieldTitle = $("fieldset.locale-it #application_translations_attributes_0_title");
                let fieldAlanteTitle = $("fieldset.inputs #application_atlante_title");
                let fieldAtlanteCode = $("fieldset.inputs #application_atlante_code");
                if (fieldTitle.val() == "" || fieldTitle.val() == result.titolo) {
                    fieldTitle.val(result.titolo);
                    fieldAlanteTitle.val(result.titolo);
                    fieldAtlanteCode.val(result.codice);
                } else {
                    ActiveAdmin.ModalDialog($target.data('message'), {}, function() {
                        fieldTitle.val(result.titolo);
                        fieldAlanteTitle.val(result.titolo)
                        fieldAtlanteCode.val(result.codice);
                    })
                }
            },
            dataType: 'json'
        });
    });
});