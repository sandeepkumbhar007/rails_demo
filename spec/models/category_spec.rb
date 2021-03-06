require 'rails_helper'

RSpec.describe Category, :type => :model do
  let(:category) { FactoryGirl.create(:category) }
  let(:category_1) { FactoryGirl.create(:category, :category_with_empty_name) }
  let(:category_2) { FactoryGirl.create(:category, :category_with_no_thumurl) }

  it "Category name should not be empty" do
    expect(category.name).not_to be_empty
  end

  it "Category thumburl should have 'http' or 'https' as prefix" do
    expect(category.thumburl).to match( /^http(s?)\W/)
  end

  # negative test cases
  
  it "Category name should not contain numeric values" do
    expect(category.name).to be_a(String)
  end

  it "Category thumburl should not be empty" do
    expect(category.thumburl).not_to be_empty
  end

  it "creating category without name should raise error" do
    expect{ category_1.save }.to raise_error( ActiveRecord::RecordInvalid )
  end

  it "creating category without thumburl should raise error" do
    expect{ category_2.save }.to raise_error( ActiveRecord::RecordInvalid )
  end
end
