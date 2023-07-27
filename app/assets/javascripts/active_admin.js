//= require active_admin/base
//= require activeadmin_addons/all
//= require active_material
//= require it
//= require datepicker-it

$.fn.select2.defaults.set('language', $.fn.select2.amd.require("select2/i18n/it"));
// $.fn.select2.defaults.set('dropdownCssClass',':all:'); Funziona solo sul container
$.fn.select2.defaults.set('templateResult', function (data, container) {
    if (data.element) {
        $(container).addClass($(data.element).attr("class"));
    }
    return data.text;
})

$.datepicker.setDefaults({}, $.datepicker.regional['it']);

$(document).ready(function () {

    function stripText(element) {
        element.contents().filter(function(){
            return (this.nodeType == 3);
        }).remove();
        return element
    }

    function changeAddIcon(container, klass="") {
        let addButton = container.find('.button.has_many_add');
        addButton.addClass("customized");
        addButton.addClass(klass);
        addButton.html('<span class="fa-stack fa-2x"><i class="fa fa-plus-circle"></i></span>');
    }

    function changeRemoveIcon(fieldset) {
        let removeButton = fieldset.find('> ol > li > .button.has_many_remove');
        if (fieldset.closest('.learning_opportunities').length > 0)
        {
            removeButton.addClass("customized-learning-opportunity")
        } else {
            removeButton.html('<span class="fa-2x"><i class="fa fa-trash"></i></span>');
            let input = fieldset.find('input:visible').not(":checkbox");
            input.css("width", 'calc(100% - 40px)')
            removeButton.addClass("customized")
            removeButton.insertAfter(input)
        }
    }

    function changeDeleteInput(fieldset) {
        let removeButton = fieldset.find('> ol > li.boolean.has_many_delete');
        if (fieldset.closest('.learning_opportunities').length > 0)
        {
            removeButton.addClass("customized-learning-opportunity")
        } else {
            stripText(removeButton.find('label'));
            let input = fieldset.find("input:visible").not(":checkbox");
            input.css("width", 'calc(100% - 40px)')
            removeButton.addClass("customized").attr('title', 'Rimuovi al salvataggio');
        }

    }


    $('.has_many_container').each(function(i, c) {
        changeAddIcon($(c), "add_competenza");
        $(c).find("fieldset").each(function(i, c) {
            changeRemoveIcon($(c))
            changeDeleteInput($(c))
        });
        if ($(c).hasClass('competences')) {
            $(c).find("fieldset.inputs.has_many_fields > ol > div.hide").each(function(i, b) {
                $(b).closest("fieldset.inputs.has_many_fields").hide();
            });
        }

    });

    $(document).on('has_many_add:after', function(e, fieldset) {
        fieldset.find('.has_many_container').each(function(i, c) {
            changeAddIcon($(c), 'add_internal');
        });
        changeRemoveIcon(fieldset)
        changeDeleteInput(fieldset)
    });


    $('.atlante-adas').on("select2:select", function (e) {
        let $target = $(e.target);
        ActiveAdmin.ModalDialog($target.data('message'), {}, function() {
            var input = $("<input>").attr("type", "hidden").attr("name", "build_nested").val(true);
            $target.closest("form").append(input).submit();
        })
    });

    let $commentsInt = $("div[id^=active_admin_comments_for_application_][class*=integration_form]")
    let $commentsAcc = $("div[id^=active_admin_comments_for_application_][class*=accept_form]")
    $commentsInt.hide()
    $commentsAcc.hide()
    $('button.button.integration_request').on("click", function (){
        if ($commentsInt.is(":visible")) {
            $commentsInt.hide();
        } else {
            $commentsInt.show();
            $commentsAcc.hide();
        }

    });
    //
    $('button.button.accept').on("click", function (){
        if ($commentsAcc.is(":visible")) {
            $commentsAcc.hide();
        } else {
            $commentsAcc.show();
            $commentsInt.hide();
        }

    });

    // workaround per selezionare nei filtri "Urgenti" la chiave
    let $element = $("select#q_sent_at_eq")
    if ($element.length > 0) {
        const urlParams = new URLSearchParams(window.location.search);
        const value = urlParams.get('q[sent_at_eq]')
        if (value) {
            console.log(value)
            $element.val(value).trigger('change');
        }
    }
});