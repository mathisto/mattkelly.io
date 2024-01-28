class UtterancesController < ApplicationController
  before_action :set_utterance, only: %i[show edit update destroy]

  # GET /utterances
  def index
    @utterances = Utterance.all
  end

  # GET /utterances/1
  def show
  end

  # GET /utterances/new
  def new
    @utterance = Utterance.new
  end

  # GET /utterances/1/edit
  def edit
  end

  # POST /utterances
  def create
    @utterance = Utterance.new(utterance_params)

    if @utterance.save
      redirect_to @utterance, notice: "Utterance was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /utterances/1
  def update
    if @utterance.update(utterance_params)
      redirect_to @utterance, notice: "Utterance was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /utterances/1
  def destroy
    @utterance.destroy!
    redirect_to utterances_url, notice: "Utterance was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_utterance
    @utterance = Utterance.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def utterance_params
    params.require(:utterance).permit(:text, :user_agent)
  end
end
