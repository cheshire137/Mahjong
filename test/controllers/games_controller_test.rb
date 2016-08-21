require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    create(:layout)
    Tile.create_all_tiles
  end

  test 'maintains my game while not signed in' do
    get :temporary
    assert_response :success

    tiles = response.body.match(/data-tiles="(#{Game::TILES_REGEX})"/)[1]

    get :temporary
    assert_equal tiles,
        response.body.match(/data-tiles="(#{Game::TILES_REGEX})"/)[1],
        'Tiles should remain the same on page reload'
  end

  test 'creates a game for me on sign in if none in progress' do
    user = create(:user)
    assert_difference 'user.games.count' do
      sign_in user
      get :index
      assert_redirected_to game_path(Game.last)
    end
  end
end
