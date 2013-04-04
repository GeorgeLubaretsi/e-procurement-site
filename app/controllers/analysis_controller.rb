#!/bin/env ruby
# encoding: utf-8

class AnalysisController < ApplicationController
include GraphHelper 
  def index
    @years = []
    AggregateStatistic.all.each do |dbYear|
      if dbYear.year > 0 
        @years.push(dbYear.year)
      end
    end
  end
  
  def generate
    year = params[:year]
    stats = AggregateStatistic.where(:year => year).first

    #reconstruct stat structure
    @info = { 
            "simple electronic" => {},
            "electronic" => {},
            "total" => {}
            }
    @info.each do |type, data|
      typeData = AggregateStatisticType.where(:aggregate_statistic_id => stats.id, :name => type).first
      #get tender data
      data[:tenderInfo] = AggregateTenderStatistic.where(:aggregate_statistic_type_id => typeData.id).first
      data[:name] = type
      data[:bidInfo] = []
      bidData = AggregateBidStatistic.where(:aggregate_statistic_type_id => typeData.id)
      bidData.each do |bidStat|
        data[:bidInfo].push([bidStat.duration,bidStat.average_bids,bidStat.tender_count])
      end
      cpvData = AggregateCpvStatistic.where(:aggregate_statistic_type_id => typeData.id)
      cpvTree = {}
      cpvData.each do |cpv|
        #get cpv name
        code = cpv.cpv_code
        name = TenderCpvClassifier.where(:cpv_code => code).first.description_english
        if not name
          name = "99999999"
        end
        cpvTree[code] = { :name => name, :code => code.to_s, :value => cpv.value, :children => [] }
      end
      data[:cpvTree] = createTreeGraphStringFromAgreements( cpvTree )
    end   

    respond_to do |format|  
      format.js   
    end
  end
end