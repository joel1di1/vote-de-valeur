// Lorsqu'une valeur est choisie, on affiche la selection
$(function(){
    $("input[type='radio']").change(function(){
        $("input[name='"+this.name+"']")
            .each(function (){
                unhighlight_label(this.id)
            })
            .filter("[checked]")
            .each(function (){
                highlight_label(this.id)
            })
    })
})

function highlight_label(for_s){
    $("label[for='"+for_s+"']")
        .addClass("selected")
        .removeClass("unselected")
}
function unhighlight_label(for_s){
    $("label[for='"+for_s+"']")
        .addClass("unselected")
        .removeClass("selected")
}

// transformer les radios du vote classique
$(function(){
    $("label.collection_radio").addClass('unselected')
    $("input[type='radio']").addClass('hidden')
        .filter("[checked]").each(function(){
            highlight_label(this.id)
        })
})
