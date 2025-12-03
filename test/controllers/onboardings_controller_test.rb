require "test_helper"

class OnboardingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @onboarding = onboardings(:one)
  end

  test "should get index" do
    get onboardings_url
    assert_response :success
  end

  test "should get new" do
    get new_onboarding_url
    assert_response :success
  end

  test "should create onboarding" do
    assert_difference("Onboarding.count") do
      post onboardings_url, params: { onboarding: { description: @onboarding.description, hubspot_id: @onboarding.hubspot_id, title: @onboarding.title, user_id: @onboarding.user_id } }
    end

    assert_redirected_to onboarding_url(Onboarding.last)
  end

  test "should show onboarding" do
    get onboarding_url(@onboarding)
    assert_response :success
  end

  test "should get edit" do
    get edit_onboarding_url(@onboarding)
    assert_response :success
  end

  test "should update onboarding" do
    patch onboarding_url(@onboarding), params: { onboarding: { description: @onboarding.description, hubspot_id: @onboarding.hubspot_id, title: @onboarding.title, user_id: @onboarding.user_id } }
    assert_redirected_to onboarding_url(@onboarding)
  end

  test "should destroy onboarding" do
    assert_difference("Onboarding.count", -1) do
      delete onboarding_url(@onboarding)
    end

    assert_redirected_to onboardings_url
  end
end
