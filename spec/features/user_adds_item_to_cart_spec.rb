require "rails_helper"

RSpec.feature "A user" do
  context "adds item to cart" do
    xscenario "and sees the item title" do
      # create(:item)
      visit "/menu"
      click_button("Add To Cart")
      click_on "Cart"
      within("#item_title") do
        expect(page).to have_content "Sushi"
      end
    end

    xscenario "and sees the item quantity" do
      # create(:item)
      visit "/menu"
      click_button("Add To Cart")
      click_on "Cart"
      within("#item_quantity") do
        expect(page).to have_content 1
      end
    end

    xscenario "and sees the item price" do
      # create(:item)
      visit "/menu"
      click_button("Add To Cart")
      click_on "Cart"
      within("#item_price") do
        expect(page).to have_content "$11.00"
      end
    end
  end

  context "adds existing item to the cart" do
    xscenario "and the item quantity is increased" do
      # create(:item)
      visit "/menu"
      click_button("Add To Cart")
      click_on "Cart"
      within("#item_quantity") do
        expect(page).to have_content 1
      end
      visit "/menu"
      click_button("Add To Cart")
      click_on "Cart"
      within("#item_quantity") do
        expect(page).to have_content 2
      end
    end

    context "removes item from cart" do
      xscenario "and the item is removed" do
        # create(:item)
        visit "/menu"
        click_button("Add To Cart")
        click_on "Cart"
        click_link_or_button("Remove From Cart")
        expect(page).to_not have_content "Sushi"
      end
    end

    context "can change quantity of item in cart" do
      xscenario "the item's quantity can be increased by one" do
        # create(:item)
        visit "/menu"
        click_button("Add To Cart")
        click_on "Cart"
        within("#item_quantity") do
          expect(page).to have_content 1
        end
        click_link_or_button("+1")
        within("#item_quantity") do
          expect(page).to have_content 2
        end
      end

      xscenario "the item's quantity can be decreased by one" do
        # create(:item)
        visit "/menu"
        click_button("Add To Cart")
        click_on "Cart"
        within("#item_quantity") do
          expect(page).to have_content 1
        end
        click_link_or_button("+1")
        within("#item_quantity") do
          expect(page).to have_content 2
        end
        click_link_or_button("-1")
        within("#item_quantity") do
          expect(page).to have_content 1
        end
      end

      xscenario "the item will be deleted if the quantity is decreased to 0" do
        # create(:item)
        visit "/menu"
        click_button("Add To Cart")
        click_on "Cart"
        within("#item_quantity") do
          expect(page).to have_content 1
        end
        expect(page).to have_content "Sushi"
        click_link_or_button("-1")
        expect(page).to_not have_content "Sushi"
      end
    end

    context "can not submit order without being logged in" do
      xscenario "with items in the cart" do
        # create(:item)
        visit "/menu"
        click_button("Add To Cart")
        click_on "Cart"
        within("#item_quantity") do
          expect(page).to have_content 1
        end
        click_link_or_button("Submit Order")
        expect(current_path).to eq(login_path)
      end

    xscenario "logging in does not clear the cart" do
      user = User.create(full_name: "dg",
                         email: "example@example.com",
                         password: "password",
                         display_name: "example name")
      # create(:item)
      visit "/menu"
      within("#items") do
        click_link_or_button "Add To Cart"
      end
      visit "/cart"
      expect(page).to have_content("Sushi")
      expect(page).to_not have_content("Onigiri")
      expect(page).to have_content("1")
      visit "/login"
      fill_in("session[email]", with: user.email)
      fill_in("session[password]", with: user.password)
      click_link_or_button "Login"
      expect(page).to have_content("Welcome to the dojo")
      visit "/cart"
      expect(page).to have_content("Sushi")
      expect(page).to_not have_content("Onigiri")
      expect(page).to have_content("1")
    end
    end
  end
end
