require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Sample App') }
    it { should have_title("#{base_title}") }
    it { should_not have_title("| Home") }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title("#{base_title} | Help") }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About Us') }
    it { should have_title("#{base_title} | About") }
  end


  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title("#{base_title} | Contact") }
    it { should have_selector("h1", text: "Contact") }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title("#{base_title} | About")

    click_link "Help"
    expect(page).to have_title("#{base_title} | Help")

    click_link "Contact"
    expect(page).to have_title("#{base_title} | Contact")

    click_link "Home"

    click_link "Sign up now!"
    expect(page).to have_title("#{base_title} | Sign up")

    click_link "sample app"
    expect(page).to have_title("#{base_title}")
  end
end