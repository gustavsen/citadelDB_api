require 'spec_helper'
include WithRollback

describe 'Killmail model' do
  describe 'killmail_data' do
    context 'with package' do
      let(:killmail_fixture) { { package: { 'killID' => 22 } } }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns data' do
        expect(killmail.killmail_data['killID']).to eq(22)
      end
    end
    context 'without package' do
      let(:killmail_fixture) { { 'killID' => 22 } }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns data' do
        expect(killmail.killmail_data['killID']).to eq(22)
      end
    end
    context 'null package' do
      let(:killmail_fixture) { File.read('./spec/fixtures/null_package.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns nil' do
        expect(killmail.killmail_data).to eq(nil)
      end
    end
  end

  describe 'system_id_lookup' do
    context 'given a valid system ID' do
      let(:killmail) { Killmail.new }
      it 'returns the system name' do
        expect(killmail.system_id_lookup(30001291)).to eq('Y-4CFK')
      end
    end
  end

  describe 'citadel_type_lookup' do
    context 'given shipTypeID' do
      let(:killmail) { Killmail.new }
      it 'returns the correct name' do
        expect(killmail.citadel_type_lookup('35832')).to eq('Astrahus')
      end
    end
  end

  describe 'check_if_citadel' do
    context 'Astrahus killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Astrahus deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Fortizar killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/fortizar_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Fortizar deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/fortizar_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Keepstar killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/keepstar_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Keepstar deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/keepstar_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'upwell killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/upwell_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'upwell deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/upwell_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'is not a citadel' do
      let(:killmail_fixture) { File.read('./spec/fixtures/ship_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel?).to eq false
      end
    end
  end

  describe 'generate_citadel_hash' do
    context 'with a valid killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:target) do
        {
          system: 'E8-YS9',
          citadel_type: 'Astrahus',
          corporation: 'Forge Industrial Command',
          alliance: 'FUBAR.',
          killed_at: nil
        }
      end
      it 'creates a hash for creating a new citadel' do
        expect(killmail.generate_citadel_hash).to eq target
      end
    end
    context 'with a valid deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:target) do
        {
          system: 'Jaschercis',
          citadel_type: 'Astrahus',
          corporation: 'Tokenada Technical Enterprises',
          alliance: nil,
          killed_at: '2016.06.29 03:26:16'
        }
      end
      it 'creates a hash for creating a new citadel' do
        expect(killmail.generate_citadel_hash).to eq target
      end
    end
    context 'it receives a null package' do
      let(:killmail_fixture) { File.read('./spec/fixtures/null_package.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'does not generate citadel' do
        expect do
          killmail.find_or_create_citadel
        end.to change(Citadel, :count).by 0
      end
    end
  end

  describe 'generate_citadel_hash_past' do
    context 'receives valid killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:target) do
        {
          system: '6-4V20',
          citadel_type: 'Fortizar',
          corporation: 'Motiveless Malignity',
          alliance: '',
          killed_at: nil
        }
      end
      it 'creates a hash to create a new citadel' do
        expect(killmail.generate_citadel_hash_past).to eq(target)
      end
    end
    context 'receives valid killmail with multiple attackers' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_killmail_multiple.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:target) do
        {
          system: 'J115405',
          citadel_type: 'Keepstar',
          corporation: 'Hard Knocks Inc.',
          alliance: '',
          killed_at: nil
        }
      end
      it 'creates a hash to create a new citadel' do
        expect(killmail.generate_citadel_hash_past).to eq(target)
      end
    end
    context 'receives valid deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_single.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:target) do
        {
          system: '93PI-4',
          citadel_type: 'Astrahus',
          corporation: 'Pandemic Horde Inc.',
          alliance: 'Pandemic Horde',
          killed_at: '2016-07-03 05:39:24'
        }
      end
      it 'creates a hash to create a new citadel' do
        expect(killmail.generate_citadel_hash_past).to eq(target)
      end
    end
  end

  describe 'find_or_create_citadel' do
    let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
    let(:killmail_fixture2) { File.read('./spec/fixtures/astrahus_killmail.json') }
    let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
    let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
    context 'citadel does not exist' do
      it 'creates a citadel instance' do
        temporarily do
          citadel = killmail.find_or_create_citadel
          expect(citadel.system).to eq('E8-YS9')
          expect(citadel.citadel_type).to eq('Astrahus')
          expect(citadel.corporation).to eq('Forge Industrial Command')
          expect(citadel.alliance).to eq('FUBAR.')
          expect(citadel.killed_at).to eq(nil)
          expect(Citadel.count).to eq(1)
        end
      end
    end
    context 'citadel already exists' do
      it 'it does not create duplicate instance' do
        temporarily do
          Citadel.create(killmail2.generate_citadel_hash)
          expect do
            citadel = killmail.find_or_create_citadel
            expect(citadel.system).to eq('E8-YS9')
            expect(citadel.citadel_type).to eq('Astrahus')
            expect(citadel.corporation).to eq('Forge Industrial Command')
            expect(citadel.alliance).to eq('FUBAR.')
            expect(citadel.killed_at).to eq(nil)
          end.to change(Citadel, :count).by 0
          expect(Citadel.count).to eq(1)
        end
      end
    end
  end

  describe 'find_or_create_citadel_past' do
    let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_single.json') }
    let(:killmail_fixture2) { File.read('./spec/fixtures/past_mail_single.json') }
    let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
    let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
    context 'citadel does not exist' do
      temporarily do
        it 'raises the citadel count by 1' do
          expect do
            citadel = killmail.find_or_create_citadel_past
            expect(citadel.system).to eq('93PI-4')
            expect(citadel.citadel_type).to eq('Astrahus')
            expect(citadel.corporation).to eq('Pandemic Horde Inc.')
            expect(citadel.alliance).to eq('Pandemic Horde')
            expect(citadel.killed_at).to eq('2016-07-03 05:39:24')
          end.to change(Citadel, :count).by 1
        end
      end
    end
    context 'citadel already exists' do
      temporarily do
        it 'does not raise citadel count' do
          Citadel.create(killmail2.generate_citadel_hash_past)
          expect do
            citadel = killmail.find_or_create_citadel_past
            expect(citadel.system).to eq('93PI-4')
            expect(citadel.citadel_type).to eq('Astrahus')
            expect(citadel.corporation).to eq('Pandemic Horde Inc.')
            expect(citadel.alliance).to eq('Pandemic Horde')
            expect(citadel.killed_at).to eq('2016-07-03 05:39:24')
          end.to change(Citadel, :count).by 0
        end
      end
    end
  end

  describe 'save_if_relevant' do
    let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
    let(:ship_killmail_fixture) { File.read('./spec/fixtures/ship_killmail.json') }
    let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
    let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
    context 'new killmail' do
      it 'saves to db' do
        temporarily do
          citadel = killmail.find_or_create_citadel
          killmail.save_if_relevant
          expect(killmail.citadel_id).to eq(citadel.id)
          expect(killmail.killmail_id).to eq(killmail.killmail_data['killID'])
          expect(Killmail.count).to eq(1)
        end
      end
      context 'duplicate killmail' do
        it 'does not save' do
          temporarily do
            killmail.save_if_relevant
            killmail2.save_if_relevant
            expect(Killmail.count).to eq(1)
          end
        end
      end
      context 'not relevant report' do
        let(:ship_killmail) { Killmail.new(killmail_json: ship_killmail_fixture) }
        it 'does not save' do
          temporarily do
            expect do
              expect(ship_killmail.save_if_relevant).to be_falsey
            end.to change(Killmail, :count).by 0
          end
        end
      end
    end
  end

  describe 'save_if_relevant_past' do
    let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_single.json') }
    let(:ship_killmail_fixture) { File.read('./spec/fixtures/past_mail_ship.json') }
    let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
    let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
    context 'new killmail' do
      it 'saves to db' do
        temporarily do
          citadel = killmail.find_or_create_citadel_past
          killmail.save_if_relevant_past
          expect(killmail.citadel_id).to eq(citadel.id)
          expect(killmail.killmail_id).to eq(killmail.killmail_data['killID'])
          expect(Killmail.count).to eq(1)
        end
      end
    end
    context 'duplicate killmail' do
      it 'does not save' do
        temporarily do
          killmail.save_if_relevant_past
          killmail2.save_if_relevant_past
          expect(Killmail.count).to eq(1)
        end
      end
    end
    context 'not relevant report' do
      let(:ship_killmail) { Killmail.new(killmail_json: ship_killmail_fixture) }
      it 'does not save' do
        temporarily do
          expect do
            expect(ship_killmail.save_if_relevant_past).to be_falsey
          end.to change(Killmail, :count).by 0
        end
      end
    end
  end

  it 'parses large api return'

  it 'updates citadel if destroyed'

  it 'add region?'
end
