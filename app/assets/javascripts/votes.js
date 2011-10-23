
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
        .removeClass("unselected nonselected")
}
function unhighlight_label(for_s){
    $("label[for='"+for_s+"']")
        .addClass("nonselected")
        .removeClass("selected unselected")
}

// transformer les radios du vote classique
$(function(){
    $("label.collection_radio").addClass('unselected')
    $("#user_votes label.collection_radio").html('')
    $("input[type='radio']").addClass('hidden')
        .filter("[checked]").each(function(){
            highlight_label(this.id)
        })
})

function confirm_empty(){

}
// alerte sur les votes vides
$(function(){
    $('#user_vote_form').submit(function(){
        var names = []
        $("#user_votes input[type='radio']").each(function(){
            if ($.inArray(this.name, names)==-1){
                names.push(this.name)
            }
        })

        var checked_names = []
        $("#user_votes input[type='radio']:checked").each(function(){
            if ($.inArray(this.name, checked_names)==-1){
                checked_names.push(this.name)
            }
        })

        if (checked_names.length != names.length){
            return confirm("Vous navez pas voter pour tous les candidats, les votes vides seront comptabilisés comme '0', êtes-vous surs de vouloir laisser les chois x vides ?")
        }
    })
})
