
// Lorsqu'une valeur est choisie, on affiche la selection
$(function(){
    $("#user_votes input[type='radio'], #classic_vote input[type='radio']").click(function(){
    	alert("click:::"+this.name);
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

// toggle vdv et classic
$(function(){
    $(window).bind( 'hashchange', function(e) {
        if ('/votes' == e.target.location.pathname){
            var hash = e.target.location.hash
            if ('#classic' == hash){
                $("#user_votes, #next_to_classic").hide()
                $("#classic_vote, #submit_votes").show()
                $("#content").removeClass('blue').addClass('grey')
            } else if ('' == hash){
                $("#classic_vote, #submit_votes").hide()
                $("#user_votes, #next_to_classic").show()
                $("#content").removeClass('grey').addClass('blue')
            }
        }
    })
    $(window).trigger( 'hashchange' );
})

if (window.location.hash == '#classic'){
    window.location.href = '/votes'
}
