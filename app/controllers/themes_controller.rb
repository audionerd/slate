class ThemesController < ResourcesController
  resources_controller_for :theme
  
public
  # Refreshes theme (SCM 'update')
  def refresh
    @theme = Theme.find(params[:id])
    flash[:notice] = @theme.update
    redirect_to resources_url
  end

  # Installs theme
  def create
    @theme = Theme.new(params[:theme])
    flash[:notice] = @theme.install
    redirect_to resources_url
  end
  
  # Removes a theme
  def destroy
    Theme.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted theme"
    redirect_to resources_url
  end
end