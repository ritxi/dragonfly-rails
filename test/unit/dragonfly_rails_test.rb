require File.expand_path('../../test_helper', __FILE__)


class DragonflyRailsTest < Test::Unit::TestCase
  def setup
    @file_path = File.expand_path('../../fixtures/image/Unknown.jpg', __FILE__)
    @file_path2 = File.expand_path('../../fixtures/image/Participa original.jpg', __FILE__)
    config = Rails.configuration
    FileUtils::rm_rf config.dragonfly_rails.assets_path
    @tools = ::DragonflyRails::StoringScope::Tools
  end
  
  should "Get application configuration" do
    config = Rails.configuration
    assert_equal('hello', config.dragonfly_rails.security_key)
    assert_equal(true, config.dragonfly_rails.protect_from_dos_attacks)
    assert_equal('photos', config.dragonfly_rails.route_path)
  end
  should "Get time_partition path" do
    partition = @tools::time_partition
    assert(/\d{4}\/\d{2}\/\d{2}\/\d{2}\/\d{2}\/\d{2}\/\d{2,3}/.match(partition))
  end
  should "Get id_partition path" do
    assert_equal('000/000/001', @tools::id_partition(1))
  end
  should "Get filename" do
    assert_equal('hello_my_world.jpg', @tools::filename_for('hello my world.jpg'))
  end
  should "have image_accessor, dragonfly_for class methods(User)" do
    assert(User.respond_to?(:image_accessor))
    assert(User.respond_to?(:dragonfly_for))
  end
  should "have image_accessor, dragonfly_for class methods(Image)" do
    assert(Image.respond_to?(:image_accessor))
    assert(Image.respond_to?(:dragonfly_for))
  end
  should "have partion_style instace method" do
    assert(User.new.respond_to?(:path_style))
  end
  should "find defined scope" do
    assert_equal('avatars', User.df_scope)
  end
  should "have generate_path instance method" do
    params = { :name => 'Ricard', :email => 'ricard@kaltha.com', :avatar => File.open(@file_path) }
    user =  User.new(params)
    
    assert( user.respond_to?(:avatar))
  end

  should "Get user avatar uid(with custom scope)" do
    params = { :name => 'Ricard', :email => 'ricard@kaltha.com', :avatar => File.open(@file_path) }
    user = User.new(params)
    path_style = user.path_style
    assert_equal(:id_partition, path_style)
    user.save
    assert_equal('avatars/000/000/001/Unknown.jpg', user.avatar_uid)
  end
  
  should "Get image uid(with default scope)" do
    params = { :image => File.open(@file_path) }
    image = Image.new(params)
    path_style = image.path_style
    assert_equal(:id_partition, path_style)
    image.save
    assert_equal('images/000/000/001/Unknown.jpg', image.image_uid)
  end
  should "update image" do
    params = { :image => File.open(@file_path) }
    image = Image.new(params)
    path_style = image.path_style
    assert_equal(:id_partition, path_style)
    image.save
    assert_equal('images/000/000/002/Unknown.jpg', image.image_uid)
    image.image = File.open(@file_path2)
    image.save
    assert_equal('images/000/000/002/Participa_original.jpg', image.image_uid)
  end
end