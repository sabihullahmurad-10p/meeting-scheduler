require 'rspec'
require_relative '../services/meeting_scheduler'

shared_examples 'meeting list not valid' do
  it 'raises meeting list not valid exception' do
    expect { scheduled_meeting }.to raise_error 'Meeting List not Valid'
  end
end

describe 'MeetingScheduler' do
  let(:scheduled_meeting) { MeetingScheduler.call(meetings) }
  describe '#call' do
    context 'when meetings are valid to be scheduled' do
      context 'with first combination' do
        let(:meetings) do
          [
            { name: 'Meeting 1', duration: 3, type: :onsite },
            { name: 'Meeting 2', duration: 2, type: :offsite },
            { name: 'Meeting 3', duration: 1, type: :offsite },
            { name: 'Meeting 4', duration: 0.5, type: :onsite }
          ]
        end
        it 'schedules meetings' do
          expect(scheduled_meeting.count).to eq(4)
          expect(scheduled_meeting[0]).to eq({ name: 'Meeting 1', start_time: '09:00', end_time: '12:00' })
          expect(scheduled_meeting[1]).to eq({ name: 'Meeting 4', start_time: '12:00', end_time: '12:30' })
          expect(scheduled_meeting[2]).to eq({ name: 'Meeting 2', start_time: '01:00', end_time: '03:00' })
          expect(scheduled_meeting[3]).to eq({ name: 'Meeting 3', start_time: '03:30', end_time: '04:30' })
        end
      end
      context 'with second combination' do
        let(:meetings) do
          [
            { name: 'Meeting 1', duration: 0.5, type: :offsite },
            { name: 'Meeting 2', duration: 0.5, type: :onsite },
            { name: 'Meeting 3', duration: 2.5, type: :offsite },
            { name: 'Meeting 4', duration: 3, type: :onsite }
          ]
        end
        it 'schedules meetings' do
          expect(scheduled_meeting.count).to eq(4)
          expect(scheduled_meeting[0]).to eq({ name: 'Meeting 2', start_time: '09:00', end_time: '09:30' })
          expect(scheduled_meeting[1]).to eq({ name: 'Meeting 4', start_time: '09:30', end_time: '12:30' })
          expect(scheduled_meeting[2]).to eq({ name: 'Meeting 1', start_time: '01:00', end_time: '01:30' })
          expect(scheduled_meeting[3]).to eq({ name: 'Meeting 3', start_time: '02:00', end_time: '04:30' })
        end
      end
      context 'with third combination' do
        let(:meetings) do
          [
            { name: 'Meeting 1', duration: 1.5, type: :onsite },
            { name: 'Meeting 2', duration: 2, type: :offsite },
            { name: 'Meeting 3', duration: 1, type: :onsite },
            { name: 'Meeting 4', duration: 1, type: :offsite },
            { name: 'Meeting 5', duration: 1, type: :offsite }
          ]
        end
        it 'schedules meetings' do
          expect(scheduled_meeting.count).to eq(5)
          expect(scheduled_meeting[0]).to eq({ name: 'Meeting 1', start_time: '09:00', end_time: '10:30' })
          expect(scheduled_meeting[1]).to eq({ name: 'Meeting 3', start_time: '10:30', end_time: '11:30' })
          expect(scheduled_meeting[2]).to eq({ name: 'Meeting 2', start_time: '12:00', end_time: '02:00' })
          expect(scheduled_meeting[3]).to eq({ name: 'Meeting 4', start_time: '02:30', end_time: '03:30' })
          expect(scheduled_meeting[4]).to eq({ name: 'Meeting 5', start_time: '04:00', end_time: '05:00' })
        end
      end
    end

    context 'when the meetings are unfit for scheduling' do
      let(:meetings) do
        [
          { name: 'Meeting 1', duration: 4, type: :offsite },
          { name: 'Meeting 2', duration: 4, type: :offsite },
        ]
      end
      it 'does not schedule meeting' do
        expect(scheduled_meeting).to be_nil
      end
    end

    context 'when the meeting list is invalid' do
      context 'when meeting list has missing duration' do
        let(:meetings) do
          [
            { name: 'Meeting 1', type: :offsite },
            { name: 'Meeting 2', duration: 0.5, type: :onsite },
            { name: 'Meeting 3', duration: 2.5, type: :offsite },
            { name: 'Meeting 4', duration: 3, type: :onsite }
          ]
        end

        it_behaves_like 'meeting list not valid'
      end

      context 'when meeting list has missing type' do
        let(:meetings) do
          [
            { name: 'Meeting 1', duration: 1.5},
            { name: 'Meeting 2', duration: 0.5, type: :onsite },
            { name: 'Meeting 3', duration: 2.5, type: :offsite },
            { name: 'Meeting 4', duration: 3, type: :onsite }
          ]
        end

        it_behaves_like 'meeting list not valid'
      end
    end
  end
end
