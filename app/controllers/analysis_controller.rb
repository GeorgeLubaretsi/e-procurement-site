#!/bin/env ruby
# encoding: utf-8

class AnalysisController < ApplicationController
include ApplicationHelper
include GraphHelper 
layout "full-screen"

  def index
    @years = []

    AggregateStatistic.all.each do |dbYear|
      if dbYear.year > 0 
        @years.push(dbYear.year)
      end
    end
    count = @years.count
    @selectedYear = @years[-1]
    @defaultAction = "cpv_revenue"
  end


  def get_tender_info(year, include_total = false )
    stats = AggregateStatistic.where(:year => year).first
    @info = { "simple electronic" => {}, "electronic" => {} }
    if include_total
      @info["total"] = {}
    end
    @info.each do |type, data|
      typeData = AggregateStatisticType.where(:aggregate_statistic_id => stats.id, :name => type).first
      data[:tenderInfo] = AggregateTenderStatistic.where(:aggregate_statistic_type_id => typeData.id).first
      data[:name] = type
    end
  end

  def get_bid_info(year)
    stats = AggregateStatistic.where(:year => year).first
    typeData = AggregateStatisticType.where(:aggregate_statistic_id => stats.id, :name => "simple electronic").first
    bidData = AggregateBidStatistic.where(:aggregate_statistic_type_id => typeData.id)
    @data = []
    @count = 0
    bidData.each do |bidStat|
      @data.push([bidStat.duration,bidStat.average_bids,bidStat.tender_count])
      @count += bidStat.tender_count
    end
    @data.sort! { |x, y| x[0] <=> y[0] }
  end

  def cpv_revenue
    @year = params[:year]
    stats = AggregateStatistic.where(:year => @year).first
    if I18n.locale == :ka
      @cpvTree = stats.cpvStringGEO
    else
      @cpvTree = stats.cpvString
    end
    respond_to do |format|  
      format.js
    end
  end

  def tender_type_amount
    @year = params[:year]
    get_tender_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def tender_type_count
    @year = params[:year]
    get_tender_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def average_bid_duration
    @year = params[:year]
    get_tender_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def average_warning_period
    @year = params[:year]
    get_tender_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def average_bidders
    @year = params[:year]
    get_tender_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def average_bids
    @year = params[:year]
    get_tender_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def more_than_one_bid
    @year = params[:year]
    get_tender_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def scatter
    @year = params[:year]
    get_bid_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def duration
    @year = params[:year]
    get_bid_info(@year)
    respond_to do |format|  
      format.js
    end
  end

  def download_cpv_data
    header = ["CPV Code","Description", "Value"]
    data = []
    
    stats = AggregateStatistic.where(:year => params[:year]).first
    typeData = AggregateStatisticType.where(:aggregate_statistic_id => stats.id, :name => "total").first
    cpvData = AggregateCpvStatistic.where(:aggregate_statistic_type_id => typeData.id)
    cpvData.each do |cpv|
      name = TenderCpvClassifier.where(:cpv_code => cpv.cpv_code).first.description_english
      if not name
        name = "Not Specified"
      end
      data.push( [cpv.cpv_code,name,cpv.value] )
    end

    respond_to do |format|
      format.csv {      
        send_data buildCSVString(header, data)
      }
    end
  end


  def getTenderStatistics( year )
    stats = AggregateStatistic.where(:year => year).first

    simpleType = AggregateStatisticType.where(:aggregate_statistic_id => stats.id, :name => "simple electronic").first
    electronicType = AggregateStatisticType.where(:aggregate_statistic_id => stats.id, :name => "electronic").first
    
    simpleData = AggregateTenderStatistic.where(:aggregate_statistic_type_id => simpleType.id).first
    electronicData = AggregateTenderStatistic.where(:aggregate_statistic_type_id => electronicType.id).first

    data = {:simple => simpleData, :electronic=> electronicData}
    return data
  end

  def download_tender_type_amount_data
    header = ["Type", "Total Value"]
    data = []
    hash = getTenderStatistics( params[:year] )

    data.push( ["Simple Electronic Tender", hash[:simple].total_value] )
    data.push( ["Electronic Tender", hash[:electronic].total_value] )
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end

  def download_tender_type_count_data
    header = ["Type", "Count"]
    data = []
    hash = getTenderStatistics( params[:year] )

    data.push( ["Simple Electronic Tender", hash[:simple].count] )
    data.push( ["Electronic Tender", hash[:electronic].count] )
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end

  def download_average_bid_duration_data
    header = ["Type", "Average Bid Duration"]
    data = []
    hash = getTenderStatistics( params[:year] )

    data.push( ["Simple Electronic Tender", hash[:simple].average_bid_duration] )
    data.push( ["Electronic Tender", hash[:electronic].average_bid_duration] )
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end

  def download_average_warning_period_data
    header = ["Type", "Average Warning Period"]
    data = []
    hash = getTenderStatistics( params[:year] )

    data.push( ["Simple Electronic Tender", hash[:simple].average_warning_period] )
    data.push( ["Electronic Tender", hash[:electronic].average_warning_period] )
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end

  def download_average_bidders_data
    header = ["Type", "Average Bidders"]
    data = []
    hash = getTenderStatistics( params[:year] )

    data.push( ["Simple Electronic Tender", hash[:simple].total_bidders.to_f/hash[:simple].count] )
    data.push( ["Electronic Tender", hash[:electronic].total_bidders.to_f/hash[:electronic].count] )
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end

  def download_average_bids_data
    header = ["Type", "Average Bids Made"]
    data = []
    hash = getTenderStatistics( params[:year] )

    data.push( ["Simple Electronic Tender", hash[:simple].total_bids.to_f/hash[:simple].count] )
    data.push( ["Electronic Tender", hash[:electronic].total_bids.to_f/hash[:electronic].count] )
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end

  def download_more_than_one_bid_data
    header = ["Type", "Percentage of tenders with atleast one bidder"]
    data = []
    hash = getTenderStatistics( params[:year] )

    data.push( ["Simple Electronic Tender", hash[:simple].success_count.to_f/hash[:simple].count] )
    data.push( ["Electronic Tender", hash[:electronic].success_count.to_f/hash[:electronic].count] )
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end

  def download_scatter_data
    header = ["Bidding Duration (days)", "Count","Average Bidders"]
    data = []
    stats = AggregateStatistic.where(:year => params[:year]).first
    simpleType = AggregateStatisticType.where(:aggregate_statistic_id => stats.id, :name => "simple electronic").first

    simpleData = AggregateBidStatistic.where(:aggregate_statistic_type_id => simpleType.id)
    simpleData.each do |bidData|
      data.push( [bidData.duration,bidData.tender_count,bidData.average_bids] )
    end
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end

  def download_duration_data
    header = ["Bidding Duration (days)", "Count"]
    data = []
    stats = AggregateStatistic.where(:year => params[:year]).first
    simpleType = AggregateStatisticType.where(:aggregate_statistic_id => stats.id, :name => "simple electronic").first

    simpleData = AggregateBidStatistic.where(:aggregate_statistic_type_id => simpleType.id)
    simpleData.each do |bidData|
      data.push( [bidData.duration,bidData.tender_count] )
    end
    
    respond_to do |format|
      format.csv {            
        send_data buildCSVString(header,data)
      }
    end
  end 

end










