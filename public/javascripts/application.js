// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function(){
    $("#user_votes input[checked='checked']").each(function (){
        highlight_label(this.id)
    })
})


$(function(){
    $("#user_votes input[type='radio']").change(function(){
        $("#user_votes input[name='"+this.name+"']")
                .each(function (){
                    unhighlight_label(this.id)
                })
                .filter("[checked]")
                .each(function (){
                    highlight_label(this.id)
                })
                .end()
    })
})


function highlight_label(for_s){
    $("label[for='"+for_s+"']").addClass("selected")
}
function unhighlight_label(for_s){
    $("label[for='"+for_s+"']").removeClass("selected")
}