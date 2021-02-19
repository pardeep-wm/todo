require 'rails_helper'
RSpec.describe Api::TodoItemsController do
  render_views
  before :all do
    @todoitem = create(:todo_item)
  end

  after :all do
    TodoItem.all.map(&:destroy)
    Tag.all.map(&:destroy)
  end

  describe 'GET index' do
    before do
      get 'index'
    end
    it 'should return json response' do
      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'should return todoitem in response' do
      expect(response).to have_http_status 200
      expect(parse_json.count).to eq 1
    end
  end

  describe 'Post create' do
    it 'should render json response' do
      post 'create', params: { todo_item: { name: 'test create', status: 'start', tags: [] } }
      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'should create new todo item' do
      post 'create', params: { todo_item: { name: 'test create 1', status: 'start', tags: [] } }
      expect(TodoItem.all.count).to eq 3
      expect(parse_json['todo_item']['name']).to eq 'test create 1'
    end

    it 'should create tags with the todo items' do
      post 'create', params: { todo_item: { name: 'item with tags', status: 'start', tags: %w[tag1 tag2] } }
      expect(Tag.all.count).to eq 2
      expect(parse_json['todo_item']['tags'].count).to eq 2
    end
  end

  describe 'PUT update/:id' do
    it 'should render json response' do
      put :update, params: { id: @todoitem.id, todo_item: { name: 'test create', status: 'start', tags: [] } }
      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'should update the todo item' do
      put :update, params: { id: @todoitem.id, todo_item: { name: 'updated name', status: 'start', tags: [] } }
      expect(parse_json['todo_item']['name']).to eq 'updated name'
    end

    it 'should update the tags of todo items' do
      put :update,
          params: { id: @todoitem.id, todo_item: { name: 'name changed', status: 'start', tags: ['updated'] } }
      expect(parse_json['todo_item']['tags'].count).to eq 1
    end
  end

  describe 'Get Items by tag' do
    before do
      post 'create', params: { todo_item: { name: 'test tag item', status: 'start', tags: ['test_tag'] } }
    end
    it 'should return the todo item for tags supplied' do
      get 'items_by_tag', params: { tag: 'test_tag' }
      expect(parse_json.count).to eq 1
    end

    it 'should return all the items if not tag supplied' do
      get 'items_by_tag'
      expect(parse_json.count).to eq 5
    end
  end

  describe 'Put mark_unmark_delete' do
    it 'should mark todo item as deleted by updated is delted parameter' do
      put 'mark_unmark_delete', params: { id: @todoitem.id }
      expect(parse_json['todo_item']['is_deleted']).to eq true
    end
  end
end
