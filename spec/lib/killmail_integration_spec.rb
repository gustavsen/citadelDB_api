require 'spec_helper'
include WithRollback

describe KillmailIntegration do
  describe 'fetch_killmail' do
    # context 'it receives a valid killmail' do
    #   fetch = KillmailIntegration.new
    #   json_data = fetch.fetch_killmail
    #   it 'has one package' do
    #     expect(json_data.first.first).to eq('package')
    #   end
    # end
  end
  describe 'parse_killmail' do
    let(:killmail_fixture) { File.read('./spec/fixtures/duplicate_killmail.json') }
    let(:killmail_fixture2) { File.read('./spec/fixtures/duplicate_killmail2.json') }
    let(:km1) { Killmail.new(killmail_json: killmail_fixture) }
    let(:km2) { Killmail.new(killmail_json: killmail_fixture2) }
    context 'citadel already exists' do
      it 'does not raise citadel count' do
        temporarily do
          km1.find_or_create_citadel
          fetcher = KillmailIntegration.new
          expect do
            fetcher.parse_killmail(killmail_fixture)
          end.to change(Citadel, :count).by 0
          expect(Citadel.count).to eq(1)
        end
      end
    end
    context "citadel doesn't exist" do
      it 'creates a new citadel' do
        temporarily do
          fetcher = KillmailIntegration.new
          expect do
            fetcher.parse_killmail(killmail_fixture)
          end.to change(Citadel, :count).by 1
          expect(Citadel.count).to eq(1)
        end
      end
    end
    context 'receives valid data' do
      it 'saves_if_relevant' do
        temporarily do
          fetcher = KillmailIntegration.new
          expect do
            fetcher.parse_killmail(killmail_fixture)
          end.to change(Killmail, :count).to eq(1)
        end
      end
    end
  end
  describe 'json_to_killmail' do
    let(:json_data) { File.read('./spec/fixtures/past_mail.json') }
    context 'it receives json with multiple Killmails' do
      it 'creates multiple killmail objects' do
        temporarily do
          KillmailIntegration.new.json_to_killmail(json_data)
          expect(Killmail.count).to be > 1
          expect(Citadel.count).to be > 1
        end
      end
    end
  end
  describe 'fetch_past_killmails' do
    it 'Astrahus killmails'
    it 'Astrahus deathmails'
    it 'Fortizar killmails'
    it 'Fortizar deathmails'
    it 'Keepstar killmails'
    it 'Keepstar deathmails'
  end

  it 'can parse large data file'
end
