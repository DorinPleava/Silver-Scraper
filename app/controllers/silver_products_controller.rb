class SilverProductsController < ApplicationController
  before_action :set_silver_product, only: %i[show edit update destroy]

  # GET /silver_products or /silver_products.json
  def index
    @silver_products = SilverProduct.all
  end

  # GET /silver_products/1 or /silver_products/1.json
  def show; end

  # GET /silver_products/new
  def new
    @silver_product = SilverProduct.new
  end

  # GET /silver_products/1/edit
  def edit; end

  # POST /silver_products or /silver_products.json
  def create
    @silver_product = SilverProduct.new(silver_product_params)

    respond_to do |format|
      if @silver_product.save
        format.html { redirect_to @silver_product, notice: 'Silver product was successfully created.' }
        format.json { render :show, status: :created, location: @silver_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @silver_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /silver_products/1 or /silver_products/1.json
  def update
    respond_to do |format|
      if @silver_product.update(silver_product_params)
        format.html { redirect_to @silver_product, notice: 'Silver product was successfully updated.' }
        format.json { render :show, status: :ok, location: @silver_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @silver_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /silver_products/1 or /silver_products/1.json
  def destroy
    @silver_product.destroy
    respond_to do |format|
      format.html { redirect_to silver_products_url, notice: 'Silver product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scrape
    url = 'https://www.acheter-or-argent.fr/pieces-en-argent.html'
    response = SilverProductSpider.process(url)
    if response[:status] == :completed && response[:error].nil?
      flash.now[:notice] = 'Successfully scraped url'
    else
      flash.now[:alert] = response[:error]
    end
  rescue StandardError => e
    flash.now[:alert] = "Error: #{e}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_silver_product
    @silver_product = SilverProduct.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def silver_product_params
    params.require(:silver_product).permit(:title, :ounces, :pieces, :price_per_oz, :in_stock, :total_price, :date_parsed)
  end
end
