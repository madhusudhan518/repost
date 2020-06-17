require 'spec_helper'

RSpec.describe Repost::Senpai do
  let(:url) { 'http://example.com/endpoint' }
  let(:html) { described_class.perform(url) }

  it 'generates post form' do
    aggregate_failures do
      expect(html).to include('form')
      expect(html).to include(url)
      expect(html).to include("type='submit'")
    end
  end

  it 'autosubmit form by default' do
    expect(html).to include('.submit()')
  end

  describe 'with params' do
    let(:params) do
      {
        name: 'TestName',
        description: 'Some cool description',
        count: 696,
        string_size: '234',
        boolean: true,
        string_boolean: 'false'
      }
    end

    let(:html) { described_class.perform(url, params: params) }

    it 'generates post form' do
      aggregate_failures do
        expect(html).to include("input type='hidden'")
        expect(html).to include("value='#{params[:name]}'")
        expect(html).to include("value='#{params[:description]}'")
        expect(html).to include("value='#{params[:string_size]}'")
        expect(html).to include("value='#{params[:string_boolean]}'")

        expect(html).to include("value='#{params[:count]}'")
        expect(html).to include("value='#{params[:boolean]}'")
      end
    end

    describe 'with nested params' do
      let(:params) do
        {
          top_level: {
            top_level_item: "hello",
            second_level: {
              third_level: "qwerty",
            },
          },
        }
      end

      it 'handles arbitrarily nested params' do
        aggregate_failures do
          expect(html).to include("name='top_level[top_level_item]' value='hello'")
          expect(html).to include("name='top_level[second_level][third_level]' value='qwerty'")
        end
      end
    end
  end

  describe 'with options' do
    let(:options) { {} }
    let(:html) { described_class.perform(url, options: options) }

    context 'empty options' do
      it 'autosubmit form by default' do
        expect(html).to include('.submit()')
      end
    end

    context 'set options' do
      describe 'autosubmit' do
        context 'enabled' do

          let(:options) do
            {
              autosubmit: true
            }
          end

          it 'returns submit function' do
            aggregate_failures do
              expect(html).to include('.submit()')
              expect(html).to include('<noscript>')
            end
          end
        end

        context 'disabled' do
          let(:options) do
            {
              autosubmit: false
            }
          end

          it "doesn't return submit function" do
            aggregate_failures do
              expect(html).to_not include('.submit()')
              expect(html).to_not include('<noscript>')
            end
          end
        end
      end

      describe 'decor' do

      end
    end
  end
end
