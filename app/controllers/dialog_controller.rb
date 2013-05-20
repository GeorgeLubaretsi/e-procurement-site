class DialogController < ApplicationController

  def showWhiteList
    orgID = params[:id]
    @item = WhiteListItem.where(:organization_id => orgID).first

    puts @item
    respond_to do |format|
      format.js {render :content_type => 'text/javascript' }
    end
  end
  
  def showBlackList
    orgID = params[:id]
    @item = BlackListItem.where(:organization_id => orgID).first
  end

end
