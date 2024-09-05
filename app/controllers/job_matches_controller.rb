class JobMatchesController < ApplicationController
    before_action :validate_params

    def create
        begin 
            jobseekers_data = params[:jobseekers].read
            jobs_data = params[:jobs].read

            service = JobMatchService.new(jobseekers_data, jobs_data)
            recommendations = service.recommend_jobs
            
            render json: recommendations
        rescue Exception => e 
            render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
        end
    end

    private 

    # Validates if both jobseekers and jobs parameters are present
    def validate_params
        unless params[:jobseekers].present? && params[:jobs].present?
            render json: { error: 'Both jobseeker and job CSV files must be provided.' }, status: :unprocessable_entity
        end
    end
end
  