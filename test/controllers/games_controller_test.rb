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

  test 'can create a new game' do
    user = create(:user)
    sign_in user
    assert_difference 'user.games.count' do
      post :create
      assert_redirected_to game_path(Game.last)
    end
  end

  test 'cannot go to game page when not signed in' do
    game = create(:game)
    get :show, params: {id: game.id}
    assert_redirected_to new_user_session_path
  end

  test 'cannot shuffle when not signed in' do
    game = create(:game)
    process :shuffle, method: :post, params: {id: game.id}
    assert_redirected_to new_user_session_path
  end

  test 'cannot create a game when not signed in' do
    assert_no_difference 'Game.count' do
      process :create, method: :post
      assert_redirected_to new_user_session_path
    end
  end

  test 'cannot match tiles in an existing game when not signed in' do
    game = build(:game)
    game.initialize_tiles
    assert game.save
    before_value = game.tiles

    tiles = before_value.split(';')
    tile1 = tiles.first
    tile1_id = tile1.split(':').first
    tile2 = tiles.detect { |t| t != tile1 && t.split(':').first == tile1_id }

    process :match, method: :post, params: {id: game.id,
                                            tiles: "#{tile1};#{tile2}"}
    assert_redirected_to new_user_session_path
    assert_equal before_value, game.reload.tiles
  end
end
