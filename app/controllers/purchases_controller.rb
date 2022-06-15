class PurchasesController < ApplicationController
  def index
    user_id = params[:user_id].to_i

    invoice_repo = InvoiceRepository.new
    @invoices = invoice_repo.get_user_invoices(user_id)
  end

  def create
    user_id = params[:user_id].to_i
    product_id = params[:product_id].to_i
    now = Time.now

    purchase_service = PurchaseService.new(
      ProductRepository.new,
      DownloadRepository.new,
      InvoiceRepository.new,
      PriceCalculator.default(ProductCatalog.new(Rails.configuration.product_catalog_path))
    )

    purchase_service.purchase(user_id, product_id, now).fold(
      if_pending: proc { render json: { error: "can't purchase product #{product_id}" }, status: :bad_request },
      if_failure: proc { |err| render json: { error: err }, status: :bad_request },
      if_success: proc { render json: {} }
    )
  end
end
