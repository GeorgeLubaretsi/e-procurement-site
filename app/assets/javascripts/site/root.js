$(function() {
  initDatePickers();
});


var displayArrows = function(sorting,direction)
{
  items = $('.arrow-link');
  for (var i = 0; i < items.length; i++) {
    image = $(items[i]).parent()
    if(sorting == items[i].classList[1]){
      if(direction == "desc"){
        image.css("background-image","url('/assets/arrow-down.png')");
      }
      else{
        image.css("background-image","url('/assets/arrow-up.png')");
      }
    }
    else{
     image.css("background-image","url('/assets/arrows.png')");
    }
  }
}

var initDatePickers = function ()
{
  $('.dp2').datepicker({ format: "yyyy/mm/dd"});
}


$(document).ready(function() {
    $('.dataTable').dataTable( {
        "sDom": '<"top"flp><"bottom"irt><"clear">',
        "sPaginationType": "full_numbers"
    } );

    $("#search-tabs").tabs({
      activate: function( event, ui ) {
          $.cookie("search_tabs_selected", $("#search-tabs").tabs("option","active"));
      },
      active: $("#search-tabs").tabs({ active: $.cookie("search_tabs_selected") })
    });

    $("#stats-tabs").tabs({
      activate: function( event, ui ) {
          $.cookie("stats_tabs_selected", $("#stats-tabs").tabs("option","active"));
      },
      active: $("#stats-tabs").tabs({ active: $.cookie("stats_tabs_selected") })
    });

    $("#account-tabs").tabs({
      activate: function( event, ui ) {
          $.cookie("account_tabs_selected", $("#account-tabs").tabs("option","active"));
      },
      active: $("#account-tabs").tabs({ active: $.cookie("account_tabs_selected") })
    });
  
    $(".vertical-tabs").tabs().addClass( "ui-tabs-vertical ui-helper-clearfix" );
    $(".vertical-tabs li").removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
    

    $('.year-option').click( function(){  
      $('.year-option').parent().removeClass('active-button');
      $(this).parent().addClass('active-button');
      var links = $('.graph-options').find('a');
      for (var i = 0; i < links.length; i++) {
        var linkObject = $(links[i]);
        var ref = linkObject.attr('href');
        ref = ref.replace(/year=(.*)/, "year="+this.text);
        linkObject.attr('href', ref);
      }
    });


   $('.graph-options').find('a').click( function() {
      $('.graph-options').find('a').parent().removeClass('active-button');
      $(this).parent().addClass('active-button');

      var startIndex = this.href.indexOf("analysis");
      startIndex = this.href.indexOf("/",startIndex);
      endIndex = this.href.indexOf("?",startIndex);
      var action = this.href.substring(startIndex+1,endIndex);

      var links = $('.year-option');
      for (var i = 0; i < links.length; i++) {
       var linkObject = $(links[i]);
       var year = linkObject.text();
       var ref = linkObject.attr('href');
       ref = ref.replace(/analysis(.*)/, "analysis/"+action+"?"+"year="+year); 
       linkObject.attr('href', ref);
      }
   });

    $( "#dialog-confirm" ).dialog({
          autoOpen: false,
          resizable: false,
          height:200,
          modal: true
    });

    $( ".confirm" ).button().click(function(e) {
      e.preventDefault();
      var targetUrl = $(this).attr("href");
      $( "#dialog-confirm" ).dialog({
          buttons: {
            "Delete": function() {
              window.location.href = targetUrl;
            },
            Cancel: function() {
              $( this ).dialog( "close" );
            }
          }
        });
        $( "#dialog-confirm" ).dialog("open");
    });
  

    /*$(".cpv-aggregate-year").click( function(){ 
      var options = $('.cpv-aggregate-group');
      for(var i = 0; i < options.length; i++){
        option = $(options[i]);
        var dataUrl = option.attr('data-url');
        index = dataUrl.indexOf("year=");
        endIndex = dataUrl.indexOf("=",index);
        url = dataUrl.substring(0,endIndex+1)+$(this).val();
        option.attr('data-url', url);
      }
    });


    $(".cpv-aggregate-group").click( function(){ 
      var options = $('.cpv-aggregate-year');
      for(var i = 0; i < options.length; i++){
        option = $(options[i]);
        var dataUrl = option.attr('data-url');
        index = dataUrl.indexOf("cpvGroup=");
        endIndex = dataUrl.indexOf("=",index);
        url = dataUrl.substring(0,endIndex+1)+$(this).val();
        option.attr('data-url', url);
      }
    });*/
});
