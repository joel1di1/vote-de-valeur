
// Lorsqu'une valeur est choisie, on affiche la selection
$(function(){
    $("#user_votes input[type='radio'], #classic_vote input[type='radio']").change(function(){
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
    $("label.collection_radio_buttons").addClass('unselected')
    $("#user_votes label.collection_radio_buttons").html('')
    $("#user_votes input[type='radio'], #classic_vote input[type='radio']").addClass('hidden')
        .filter("[checked]").each(function(){
            highlight_label(this.id)
        })
})

function user_checked_all(){
    return $("#user_votes input[type='radio']").size()/5 == $("#user_votes input[type='radio']:checked").size()
}

function user_force_zeros(){
    return confirm("Vous n'avez pas attribué de valeur à certains candidats. Là où vous ne vous êtes pas exprimé nous attribuerons automatiquement la valeur 'indifférent 0'. Êtes-vous sûr(e) de vouloir laisser le(les) choix vides ?")
}
// toggle vdv et classic
$(function(){
    $("#next_to_classic").click(function(){
        // alerte sur les votes vides
        if (user_checked_all() || user_force_zeros()){
                $("#classic_vote, #user_votes, #submit_votes").toggle()
                $("#content").removeClass('blue').addClass('grey')
                $(this).toggle()
        }
    })
})
