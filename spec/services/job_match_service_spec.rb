require 'rails_helper'

RSpec.describe JobMatchService do
    let(:jobseekers_data) do
        <<~CSV
            id,name,skills
            1,Alice,"Ruby,Python,JavaScript"
            2,Bob,"C++,Java,Python"
        CSV
    end

    let(:jobs_data) do
        <<~CSV
            id,title,required_skills
            1,Software Engineer,"Ruby,Python"
            2,Backend Developer,"C++,Java"
            3,Frontend Developer,"JavaScript,React"
        CSV
    end

    subject { JobMatchService.new(jobseekers_data, jobs_data) }

    describe '#recommend_jobs' do
        it 'returns correct job recommendations for Alice' do
            recommendations = subject.recommend_jobs

            alice_recommendations = recommendations.select { |rec| rec[:jobseeker_name] == 'Alice' }
                
            expect(alice_recommendations.size).to eq(2)

            expect(alice_recommendations[0][:job_id]).to eq("1")  # Software Engineer
            expect(alice_recommendations[0][:matching_skill_count]).to eq(2)
            expect(alice_recommendations[0][:matching_skill_percent]).to eq(100.0)

            expect(alice_recommendations[1][:job_id]).to eq("3")  # Frontend Developer
            expect(alice_recommendations[1][:matching_skill_count]).to eq(1)
            expect(alice_recommendations[1][:matching_skill_percent]).to eq(50.0)
        end

        it 'returns correct job recommendations for Bob' do
            recommendations = subject.recommend_jobs

            bob_recommendations = recommendations.select { |rec| rec[:jobseeker_name] == 'Bob' }

            expect(bob_recommendations.size).to eq(2)

            expect(bob_recommendations[0][:job_id]).to eq("2")  # Backend Developer
            expect(bob_recommendations[0][:matching_skill_count]).to eq(2)
            expect(bob_recommendations[0][:matching_skill_percent]).to eq(100.0)

            expect(bob_recommendations[1][:job_id]).to eq("1")  # Software Engineer
            expect(bob_recommendations[1][:matching_skill_count]).to eq(1)
            expect(bob_recommendations[1][:matching_skill_percent]).to eq(50.0)
        end
    end
end
