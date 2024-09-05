require 'rails_helper'

RSpec.describe JobMatchesController, type: :controller do
  # Mock CSV data for testing
  describe 'POST #create' do
    context 'with valid CSV files' do
      before do
        # Mocking uploaded files using ActionDispatch::Http::UploadedFile
        jobseekers_file = fixture_file_upload('jobseekers.csv', 'text/csv')
        jobs_file = fixture_file_upload('jobs.csv', 'text/csv')


        post :create, params: { jobseekers: jobseekers_file, jobs: jobs_file }
      end

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns recommendations in JSON format' do
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an_instance_of(Array)
        expect(json_response.first).to include('jobseeker_name', 'job_title', 'matching_skill_count', 'matching_skill_percent')
      end
    end

    context 'with missing jobseekers or jobs params' do
        it 'returns status 422 if jobseekers file is missing' do
            jobs_file = fixture_file_upload('jobs.csv', 'text/csv')
    
            post :create, params: { jobs: jobs_file }
            
            expect(response).to have_http_status(:unprocessable_content)
            expect(JSON.parse(response.body)).to eq('error' => 'Both jobseeker and job CSV files must be provided.')
        end

        it 'returns status 422 if jobs file is missing' do
            jobs_file = fixture_file_upload('jobseekers.csv', 'text/csv')
    
            post :create, params: { jobseekers: jobs_file }
    
            expect(response).to have_http_status(:unprocessable_content)
            expect(JSON.parse(response.body)).to eq('error' => 'Both jobseeker and job CSV files must be provided.')
          end
    end

    context 'when an internal error occurs' do
      it 'returns status 500 with an error message' do
        jobseekers_file = fixture_file_upload('jobseekers.csv', 'text/csv')
        jobs_file = fixture_file_upload('jobs.csv', 'text/csv')

        # Simulate error in service layer
        allow_any_instance_of(JobMatchService).to receive(:recommend_jobs).and_raise(StandardError.new("Internal Error"))

        post :create, params: { jobseekers: jobseekers_file, jobs: jobs_file }

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to eq('error' => 'Something went wrong: Internal Error')
      end
    end
  end
end
