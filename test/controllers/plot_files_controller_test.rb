require 'test_helper'

class PlotFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plot_file = plot_files(:one)
  end

  test "should get index" do
    get plot_files_url
    assert_response :success
  end

  test "should get new" do
    get new_plot_file_url
    assert_response :success
  end

  test "should create plot_file" do
    assert_difference('PlotFile.count') do
      post plot_files_url, params: { plot_file: {  } }
    end

    assert_redirected_to plot_file_url(PlotFile.last)
  end

  test "should show plot_file" do
    get plot_file_url(@plot_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_plot_file_url(@plot_file)
    assert_response :success
  end

  test "should update plot_file" do
    patch plot_file_url(@plot_file), params: { plot_file: {  } }
    assert_redirected_to plot_file_url(@plot_file)
  end

  test "should destroy plot_file" do
    assert_difference('PlotFile.count', -1) do
      delete plot_file_url(@plot_file)
    end

    assert_redirected_to plot_files_url
  end
end
