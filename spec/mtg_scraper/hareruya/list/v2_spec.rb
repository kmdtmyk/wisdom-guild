# frozen_string_literal: true

RSpec.describe MtgScraper::Hareruya::List::V2 do

  let(:page){ page = MtgScraper::Page.new(url) }
  let(:html){ page.html }
  let(:list){ MtgScraper::Hareruya::List::V2.new(html) }

  describe '#each' do

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it{ expect(list).to respond_to(:each) }
      it do
        count = 0
        list.each do |c|
          count += 1
        end
        expect(count).to eq list.size
      end
    end

  end

  describe '#size' do

    subject{ list.size }

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it{ expect(subject).to eq 60 }
    end

  end

  describe '#[]' do

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }

      example 'english foil' do
        expect(list[0]).to eq(
          name: '恩寵の天使',
          english_name: 'Angel of Grace',
          language: 'english',
          price: 3000,
          basic_land: false,
          foil: true,
          card_set_code: 'RNA',
          token: false,
          prerelease: false,
          version: nil,
        )
      end

      example 'japanese non-foil' do
        expect(list[3]).to eq(
          name: '恩寵の天使',
          english_name: 'Angel of Grace',
          language: 'japanese',
          price: 380,
          basic_land: false,
          foil: false,
          card_set_code: 'RNA',
          token: false,
          prerelease: false,
          version: nil,
        )
      end

      example 'range' do
        expect(list[0..2].class).to eq Array
        expect(list[0..2].size).to eq 3
      end

    end

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=19' }

      example 'basic land' do
        expect(list[22]).to eq(
          name: '平地',
          english_name: 'Plains',
          language: 'japanese',
          price: 80,
          basic_land: true,
          foil: false,
          card_set_code: 'RNA',
          token: false,
          prerelease: false,
          version: nil,
        )
      end

    end

    context 'prerelease' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=183' }

      example do
        expect(list[8]).to eq(
          name: '報奨密偵',
          english_name: 'Bounty Agent',
          language: 'english',
          price: 150,
          basic_land: false,
          foil: true,
          card_set_code: 'GRN',
          token: false,
          prerelease: true,
          version: nil,
        )
      end

    end

    context 'reservation' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=208' }

      example 'japanese' do
        expect(list[0]).to eq(
          name: '大いなる創造者、カーン',
          english_name: 'Karn, the Great Creator',
          language: 'japanese',
          price: 1400,
          basic_land: false,
          foil: false,
          card_set_code: 'WAR',
          prerelease: false,
          token: false,
          version: nil,
        )
      end

      example 'english' do
        expect(list[1]).to eq(
          name: '大いなる創造者、カーン',
          english_name: 'Karn, the Great Creator',
          language: 'english',
          price: 1400,
          basic_land: false,
          foil: false,
          card_set_code: 'WAR',
          prerelease: false,
          token: false,
          version: nil,
        )
      end

    end

    describe 'version' do

      context 'japanese illustration' do
        let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=208' }

        example do
          expect(list[2]).to eq(
            name: '大いなる創造者、カーン',
            english_name: 'Karn, the Great Creator',
            language: 'japanese',
            price: 2000,
            basic_land: false,
            foil: false,
            card_set_code: 'WAR',
            token: false,
            prerelease: false,
            version: '絵違い',
          )
        end

      end

      context 'Brothers Yamazaki' do
        let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=53&page=11' }

        example do
          expect(list[37]).to eq(
            name: '山崎兄弟',
            english_name: 'Brothers Yamazaki',
            language: 'japanese',
            price: 150,
            basic_land: false,
            foil: false,
            card_set_code: 'CHK',
            token: false,
            prerelease: false,
            version: 'A',
          )
        end

        example do
          expect(list[38]).to eq(
            name: '山崎兄弟',
            english_name: 'Brothers Yamazaki',
            language: 'english',
            price: 50,
            basic_land: false,
            foil: false,
            card_set_code: 'CHK',
            token: false,
            prerelease: false,
            version: 'B',
          )
        end

      end

    end

    describe 'planeswalker deck' do

      context do
        let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=183&page=14' }

        example do
          expect(list[10]).to eq(
            name: '嵐を呼ぶ者、ラル',
            english_name: 'Ral, Caller of Storms',
            language: 'english',
            price: 600,
            basic_land: false,
            foil: true,
            card_set_code: 'GRN',
            token: false,
            prerelease: false,
            version: nil,
          )
        end

      end

    end

    describe 'typo' do

      context 'Plains' do
        let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=128&page=18' }

        example do
          expect(list[12]).to eq(
            name: '平地',
            english_name: 'Plains',
            language: 'japanese',
            price: 100,
            basic_land: true,
            foil: true,
            card_set_code: 'M15',
            token: false,
            prerelease: false,
            version: nil,
          )

          expect(list[13]).to eq(
            name: '平地',
            english_name: 'Plains',
            language: 'english',
            price: 100,
            basic_land: true,
            foil: true,
            card_set_code: 'M15',
            token: false,
            prerelease: false,
            version: nil,
          )
        end

      end

      context "Baral's Expertise" do
        let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=163&page=2' }

        example do
          expect(list[58]).to eq(
            name: 'バラルの巧技',
            english_name: "Baral's Expertise",
            language: 'english',
            price: 100,
            basic_land: false,
            foil: true,
            card_set_code: 'AER',
            token: false,
            prerelease: true,
            version: nil,
          )
        end

        example do
          expect(list[59]).to eq(
            name: 'バラルの巧技',
            english_name: "Baral's Expertise",
            language: 'japanese',
            price: 100,
            basic_land: false,
            foil: true,
            card_set_code: 'AER',
            token: false,
            prerelease: true,
            version: nil,
          )
        end

      end

      context 'Hero of Precinct One' do
        let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=1' }

        example do
          expect(list[42]).to eq(
            name: '第１管区の勇士',
            english_name: 'Hero of Precinct One',
            language: 'english',
            price: 350,
            basic_land: false,
            foil: true,
            card_set_code: 'RNA',
            token: false,
            prerelease: false,
            version: nil,
          )
        end

      end

    end

    context 'box promo (Nexus of Fate)' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=181&page=5' }

      example do
        expect(list[42]).to eq(
          name: '運命のきずな',
          english_name: 'Nexus of Fate',
          language: 'english',
          price: 2480,
          basic_land: false,
          foil: true,
          card_set_code: 'M19',
          token: false,
          prerelease: false,
          version: nil,
        )
      end

      example do
        expect(list[43]).to eq(
          name: '運命のきずな',
          english_name: 'Nexus of Fate',
          language: 'japanese',
          price: 2800,
          basic_land: false,
          foil: true,
          card_set_code: 'M19',
          token: false,
          prerelease: false,
          version: nil,
        )
      end

    end

    describe 'Token' do

      context do
        let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=117' }

        example do
          expect(list[0]).to eq(
            name: '天使トークン',
            english_name: nil,
            language: 'english',
            price: 60,
            basic_land: false,
            foil: false,
            card_set_code: 'M14',
            token: true,
            prerelease: false,
            version: nil,
          )
        end

      end

      context 'Punch card' do
        let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=167&page=21' }

        example do
          expect(list[2]).to eq(
            name: 'パンチカード',
            english_name: nil,
            language: 'english',
            price: 10,
            basic_land: false,
            foil: false,
            card_set_code: 'AKH',
            token: true,
            prerelease: false,
            version: nil,
          )
        end

      end

    end

  end

  describe 'category_list' do

    subject{ list.category_list }

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it do
        expect(subject.size).to eq 138
        expect(subject[1][:name]).to eq 'ラヴニカの献身'
        expect(subject[1][:id]).to eq 188
      end
    end

  end

  describe 'next_page_url' do

    subject{ list.next_page_url }

    context 'first page' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it{ expect(subject).to eq 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=2' }
    end

    context 'middle page' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=5' }
      it{ expect(subject).to eq 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=6' }
    end

    context 'last page' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=19' }
      it{ expect(subject).to eq nil }
    end

    context 'no pagination' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search' }
      it{ expect(subject).to eq nil }
    end

  end

  describe 'total_page' do

    subject{ list.total_page }

    context 'valid page' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it{ expect(subject).to eq 19 }
    end

    context 'no pagination' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search' }
      it{ expect(subject).to eq nil }
    end

  end

end
