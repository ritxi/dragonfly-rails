require File.expand_path('../../test_helper', __FILE__)


class PaperclipTest < Test::Unit::TestCase
  def setup
    @file_path = File.expand_path('../../fixtures/image/Unknown.jpg', __FILE__)
    @file_path2 = File.expand_path('../../fixtures/image/Participa original.jpg', __FILE__)
    config = Rails.configuration
    FileUtils::rm_rf config.dragonfly_rails.assets_path
    @tools = ::DragonflyRails::StoringScope::Tools
  end
  should 'create new record' do
    paperclip = OldPaperclip.new(:pc_paperclip => File.open(@file_path))
    paperclip.save
    assert_equal("paperclips/000/000/00#{paperclip[:id]}/Unknown_original.jpg", paperclip.paperclip_uid)
  end
  should 'update record' do
    paperclip = OldPaperclip.new(:pc_paperclip => File.open(@file_path))
    paperclip.save
    assert_equal("paperclips/000/000/00#{paperclip[:id]}/Unknown_original.jpg", paperclip.paperclip_uid)
    paperclip.update_attribute(:pc_paperclip, File.open(@file_path2))
    assert_equal("paperclips/000/000/00#{paperclip[:id]}/Participa original_original.jpg", paperclip.paperclip_uid)
  end
  should 'remove files after deleting a row' do
    paperclip = OldPaperclip.new(:pc_paperclip => File.open(@file_path))
    paperclip.save
    
    file = paperclip.pc_paperclip.path
    assert(File.exist?(file))
    paperclip.destroy
    assert(!File.exist?(file))
  end
end