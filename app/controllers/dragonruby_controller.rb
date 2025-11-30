class DragonrubyController < ApplicationController
  before_action :set_wasm_headers

  def index
    @tutorials = Tutorial.all
  rescue Errno::ENOENT
    @tutorials = []
  end

  def show
    @tutorial = Tutorial.find(params[:slug])

    if turbo_frame_request?
      render layout: false
    end
  rescue Errno::ENOENT, ActiveRecord::RecordNotFound
    if turbo_frame_request?
      render turbo_stream: turbo_stream.replace(
        "tutorial-content",
        partial: "error",
        locals: { message: "Tutorial not found" }
      )
    else
      redirect_to dragonruby_path, alert: "Tutorial not found"
    end
  end

  private

  def set_wasm_headers
    response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
    response.headers["Cross-Origin-Opener-Policy"] = "same-origin"
  end
end
