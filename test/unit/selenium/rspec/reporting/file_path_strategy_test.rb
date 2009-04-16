require File.expand_path(File.dirname(__FILE__) + '/../../../unit_test_helper')

unit_tests do
  
  test "base_report_dir is resource/<name of the report> under the final report base directory" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "/some/dir/a_final_report.html"
    assert_equal File.expand_path("/some/dir"), strategy.base_report_dir
  end
  
  test "base_report_dir is distinct when the only the report name changes" do
    first_strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "/some/dir/a_final_report.html"
    second_strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "/another/dir/another_final_report.html"
    assert_equal File.expand_path("/some/dir"), first_strategy.base_report_dir
    assert_equal File.expand_path("/another/dir"), second_strategy.base_report_dir
  end
  
  test "example_hash is distinct when examples implementation is different" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "report.html"
  
    first_example = Object.new
    first_example.stubs(:location).returns('./blah/blah:6')
    
    second_example = Object.new
    second_example.stubs(:location).returns('./blah/blah:21')

    assert strategy.example_hash(first_example) != strategy.example_hash(second_example)
  end
  
  test "example_hash is the same when examples implementation is identical" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "report.html"

    first_example = Object.new
    first_example.stubs(:location).returns('./blah/blah:6')
    second_example = Object.new
    second_example.stubs(:location).returns('./blah/blah:6')
    
    assert_equal strategy.example_hash(first_example), 
                 strategy.example_hash(second_example)
  end
  
  test "relative_file_path_for_html_capture is based on the example hash" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "a_report.html"
    strategy.expects(:example_hash).with(:the_example).returns("the_hash")
    assert_equal "resources/a_report/example_the_hash.html", 
                strategy.relative_file_path_for_html_capture(:the_example)
  end

  test "relative_file_path_for_system_screenshot is based on the example hash" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "the_report.html"
    strategy.expects(:example_hash).with(:the_example).returns("the_hash")
    assert_equal "resources/the_report/example_the_hash_system_screenshot.png", 
                 strategy.relative_file_path_for_system_screenshot(:the_example)
  end

  test "relative_file_path_for_page_screenshot is based on the example hash" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "the_report.html"
    strategy.expects(:example_hash).with(:the_example).returns("the_hash")
    assert_equal "resources/the_report/example_the_hash_system_screenshot.png", 
                 strategy.relative_file_path_for_system_screenshot(:the_example)
  end

  test "relative_file_path_for_remote_control_logs is based on the example hash" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "the_report.html"
    strategy.expects(:example_hash).with(:the_example).returns("the_hash")
    assert_equal "resources/the_report/example_the_hash_remote_control.log", 
                 strategy.relative_file_path_for_remote_control_logs(:the_example)
  end
  
  test "file_path concatenate the base_report_dir and the relative path" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "report.html"
    FileUtils.stubs(:mkdir_p)
    strategy.stubs(:base_report_dir).returns("/base/report/dir")
    assert_equal "/base/report/dir/relative/path/file.html", 
                 strategy.file_path("relative/path/file.html")
  end

  test "file_path create the base_report_dir directory if it does not exists" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "report.html"
    strategy.stubs(:base_report_dir).returns("/base/report/dir")
    File.stubs(:directory?).with("/base/report/dir/relative/path").returns(false)
    
    FileUtils.expects(:mkdir_p).with("/base/report/dir/relative/path")
    strategy.file_path "relative/path/file.html"
  end

  test "file_path does not create the base_report_dir directory if it does exists" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "report.html"
    strategy.stubs(:base_report_dir).returns("/base/report/dir")
    File.stubs(:directory?).with("/base/report/dir/relative/path").returns(true)
    
    FileUtils.expects(:mkdir_p).never
    strategy.file_path "relative/path/file.html"
  end

  test "file_path_for_html_capture return the absolute file path for the html file" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "a_final_report.html"
    strategy.stubs(:example_hash).with(:the_example).returns("the_hash")

    strategy.expects(:file_path).with("resources/a_final_report/example_the_hash.html") \
            .returns(:the_absolute_file_path)    
    assert_equal :the_absolute_file_path, strategy.file_path_for_html_capture(:the_example)
  end

  test "file_path_for_system_screenshot return the absolute file path for the png file" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "a_final_report.html"
    strategy.stubs(:example_hash).with(:the_example).returns("the_hash")

    strategy.expects(:file_path).with("resources/a_final_report/example_the_hash_system_screenshot.png")\
            .returns(:the_absolute_file_path)    
    assert_equal :the_absolute_file_path, strategy.file_path_for_system_screenshot(:the_example)
  end

  test "file_path_for_page_screenshot return the absolute file path for the png file" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "a_final_report.html"
    strategy.stubs(:example_hash).with(:the_example).returns("the_hash")

    strategy.expects(:file_path).with("resources/a_final_report/example_the_hash_page_screenshot.png")\
            .returns(:the_absolute_file_path)    
    assert_equal :the_absolute_file_path, strategy.file_path_for_page_screenshot(:the_example)
  end

  test "file_path_for_remote_control_logs return the absolute file path for the log file" do
    strategy = Selenium::RSpec::Reporting::FilePathStrategy.new "a_final_report.html"
    strategy.stubs(:example_hash).with(:the_example).returns("the_hash")

    strategy.expects(:file_path).with("resources/a_final_report/example_the_hash_remote_control.log")\
            .returns(:the_absolute_file_path)    
    assert_equal :the_absolute_file_path, strategy.file_path_for_remote_control_logs(:the_example)
  end
  
end