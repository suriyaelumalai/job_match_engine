require "csv"

class JobMatchService
    def initialize(jobseekers_data, jobs_data)
        @jobseekers = parse_csv(jobseekers_data)
        @jobs = parse_csv(jobs_data)
    end

    # Method that performs the actual matching logic between jobseekers and jobs
    def recommend_jobs
        recommendations = []
        @jobseekers.each do |jobseeker|
            seeker_skills = jobseeker["skills"].split(',').map(&:strip).to_set
            
            # Iterate through each jobseeker and compare their skills with jobs
            @jobs.each do |job|
                job_skills = job["required_skills"].split(',').map(&:strip).to_set

                 # Find matching skills between jobseeker and job
                matching_skills = seeker_skills & job_skills
                match_count = matching_skills.size

                next if match_count.zero?

                match_percentage = (match_count.to_f / job_skills.size) * 100
                recommendations << {
                    jobseeker_id: jobseeker["id"].to_i,
                    jobseeker_name: jobseeker["name"],
                    job_id: job["id"],
                    job_title: job["title"],
                    matching_skill_count: match_count,
                    matching_skill_percent: match_percentage
                }
            end
        end
         # Sort the results by jobseeker id and matching percentage (highest first)
        recommendations.sort_by { |rec| [rec[:jobseeker_id], -rec[:matching_skill_percent]] }
    end

    private

    def parse_csv(data)
        CSV.parse(data, headers: true).map(&:to_h)
    end
end