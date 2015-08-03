require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Sample App') }
    it { should have_title("#{base_title}") }
    it { should_not have_title("| Home") }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
      
      describe "micropost counts" do
        before { click_link "delete", match: :first }
          it "should be singular when count eq to 1" do
        expect(page).to have_selector("span", text: "1 micropost")
        end
      end
      
      describe "micropost pagination" do
        before do
          31.times { FactoryGirl.create(:micropost, user: user) }
          sign_in user
          visit root_path
        end

        after { user.microposts.destroy_all }

        it { should have_selector("div.pagination") }
      end
    end
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