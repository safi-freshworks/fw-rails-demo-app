# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(name: 'Anything', password: '2342322r')
  end
  describe 'name field validation' do
    it 'length should be min 2' do
      expect(subject).to be_valid
      subject.name = 'ss'
      expect(subject).to_not be_valid
    end
    it 'length should be max 10' do
      subject.name = 'asdfasdfas2'
      expect(subject).to_not be_valid
      subject.name = 'asdfasdfas'
      expect(subject).to be_valid
    end
  end
end
