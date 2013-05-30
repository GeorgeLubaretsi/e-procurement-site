$(function() {
  initDatePickers();
});

var initDatePickers = function ()
{
  $('.dp2').datepicker({ format: "yyyy/mm/dd"});
}


$(document).ready(function() {
    $('.dataTable').dataTable( {
        "sDom": '<"top"flp><"bottom"irt><"clear">',
        "sPaginationType": "full_numbers"
    } );
    $( ".tabs" ).tabs();

    $('.year-option').click( function(){  
      $('.year-option').removeClass('active-button');
      $(this).addClass('active-button');
      var links = $('.graph-options').find('a');
      for (var i = 0; i < links.length; i++) {
        var linkObject = $(links[i]);
        var ref = linkObject.attr('href');
        ref = ref.replace(/year=(.*)/, "year="+this.text);
        linkObject.attr('href', ref);
      }
    });


   $('.graph-options').find('a').click( function() {
      $('.graph-options').find('a').removeClass('active-button');
      $(this).addClass('active-button');

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
});



