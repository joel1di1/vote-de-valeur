class ConfigurationsController < ApplicationController

  def index
    @configuration = Configuration.find_by_name 'current'
    @configuration = Configuration.new unless @configuration
    render :edit
  end

  def update
    @configuration = Configuration.find params[:id]
    @configuration.name = 'current'
    if @configuration.update_attributes(params[:configuration])
      flash.now[:notice] = "Configuration modifiee !!"
      render :edit
    else
      flash[:error] = "Impossible de modifier la configuration"
      redirect_to :index
    end
  end

  def create
    configuration = Configuration.find_by_name 'current'
    configuration.update_attribute :name, 'old' unless configuration.nil?

    @configuration = Configuration.new params[:configuration]
    @configuration.name = 'current'
    if @configuration.save
      flash.now[:notice] = "Configuration modifiee !!"
       render:edit
    else
      flash[:error] = "Impossible de modifier la configuration"
      redirect_to :index
    end

  end

end
