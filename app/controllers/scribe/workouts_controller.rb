module Scribe
  class WorkoutsController < ApplicationController
    before_action :set_workout, only: [ :show, :edit, :update, :destroy ]

    def index
      @q = Workout.ransack(params[:q])
      @workouts = @q.result.recent.page(params[:page])

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def show
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def new
      @workout = Workout.new
    end

    def edit
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def create
      @workout = Workout.new(workout_params)

      respond_to do |format|
        if @workout.save
          format.html { redirect_to scribe_workouts_path, notice: "Workout created successfully." }
          format.turbo_stream { flash.now[:notice] = "Workout created successfully." }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :form_errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      # Convert minutes to seconds if provided
      if params[:scribe_workout][:duration_seconds].present?
        params[:scribe_workout][:duration_seconds] = (params[:scribe_workout][:duration_seconds].to_f * 60).to_i
      end

      # Convert km to meters if provided
      if params[:scribe_workout][:distance_meters].present?
        params[:scribe_workout][:distance_meters] = (params[:scribe_workout][:distance_meters].to_f * 1000).to_i
      end

      respond_to do |format|
        if @workout.update(workout_params)
          format.html { redirect_to scribe_dashboard_path, notice: "Workout updated successfully." }
          format.turbo_stream { flash.now[:notice] = "Workout updated successfully." }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :form_errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @workout.destroy

      respond_to do |format|
        format.html { redirect_to scribe_workouts_path, notice: "Workout deleted." }
        format.turbo_stream
      end
    end

    def mark_reviewed
      @workout = Workout.find(params[:id])
      @workout.mark_as_reviewed!

      respond_to do |format|
        format.html { redirect_to scribe_workouts_path, notice: "Marked as reviewed." }
        format.turbo_stream
      end
    end

    private

    def set_workout
      @workout = Workout.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to scribe_dashboard_path, alert: "Workout not found"
    end

    def workout_params
      params.require(:scribe_workout).permit(
        :activity_type, :duration_seconds, :distance_meters,
        :calories_burned, :heart_rate_avg, :water_ml,
        :protein_grams, :weight_grams, :performed_at,
        :needs_review, :confidence_score, :original_utterance,
        metadata: {}
      )
    end
  end
end
