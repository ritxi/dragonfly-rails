require File.expand_path('../../test_helper', __FILE__)


class Tools
  extend ::Kaltha::StoringScope::Tools
end
class KalthaTest < Test::Unit::TestCase
  def setup
    @file_path = File.expand_path('../../fixtures/image/Unknown.jpeg', __FILE__)
  end
  
  should "Get application configuration" do
    config = Rails.configuration
    assert_equal('hello', config.kaltha.security_key)
    assert_equal(true, config.kaltha.protect_from_dos_attacks)
    assert_equal('photos', config.kaltha.route_path)
  end
  should "Get id_partition path" do
    assert_equal('000/000/001', Tools.id_partition(1))
  end
  should "Get filename" do
    assert_equal('hello_my_world.jpg', Tools.filename_for('hello my world.jpg'))
  end
  should "have image_accessor class method" do
    assert(User.respond_to?(:image_accessor))
  end
  should "have kaltha_dragonfly_for class method" do
    assert(User.respond_to?(:kaltha_dragonfly_for))
  end
  should "have partion_style instace method" do
    assert(User.new.respond_to?(:path_style))
  end
  should "find defined scope" do
    assert_equal('avatar', User.df_scope)
  end
  should "have generate_path instance method" do
    params = { :name => 'Ricard', :email => 'ricard@kaltha.com', :avatar => File.open(@file_path) }
    user =  User.new(params)
    assert( user.respond_to?(:avatar))
    p user.avatar.app.datastore
  end

  should "Get user avatar uid(with custom scope)" do
    params = { :name => 'Ricard', :email => 'ricard@kaltha.com', :avatar => File.open(@file_path) }
    user = User.new
    path_style = user.path_style
    assert_equal(:id_partition, path_style)
    user.save
    
    assert_equal('avatars/000/000/001/Unknown.jpeg', user.avatar_uid)
  end
  
  should "Get image uid(with default scope)" do
    params = { :image => File.open(@file_path) }
    user = Image.new
    path_style = user.path_style
    assert_equal(:id_partition, path_style)
    user.save
    
    assert_equal('images/000/000/001/Unknown.jpeg', user.image_uid)
  end
  
end