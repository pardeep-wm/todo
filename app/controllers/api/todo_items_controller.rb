# frozen_string_literal: true

module Api
  # class to manage todo api
  class TodoItemsController < ApplicationController
    respond_to? :json
    before_action :set_todo_item, only: [:update, :mark_unmark_delete]

    def index
      @todo_items = filter_todos if params[:show]
      @todo_items = TodoItem.page(params[:page]).order('id desc') unless params[:show]
      render 'index'
    end

    def create
      @todo_item = TodoItem.new(todo_item_params.except(:tags))
      @todo_item.tags << build_tags
      if @todo_item.save
        render @todo_item
      else
        render json: @todo_item.errors
      end
    end

    def update
      @todo_item.tags.map(&:destroy)
      @todo_item.tags << build_tags
      if @todo_item.update(todo_item_params.except(:tags))
        @todo_item = TodoItem.find(id: params[:id])
        render @todo_item
      else
        render json: @todo_item.errors
      end
    end

    def items_by_tag
      @todo_items = params[:tag].blank? ? TodoItem.page(params[:page]).order('id desc') : list_by_tag
      return render json: [] if @todo_items.blank?

      render 'index'
    end

    def mark_unmark_delete
      @todo_item.update(is_deleted: !@todo_item.is_deleted)
      render @todo_item
    end

    private

    def filter_todos
      return TodoItem.page(params[:page]).order('id desc') if params[:show] == 'All'

      filter = params[:show] == 'Deleted'
      TodoItem.where(is_deleted: filter).page(params[:page]).order('id desc')
    end

    def list_by_tag
      tags = params[:tag].split(',')
      tag_ids = Tag.where(:name.in => tags).pluck(:id)
      @todo_items = TodoItem.where(:tag_ids.in => tag_ids)
    end

    def todo_item_params
      params.require(:todo_item).permit(:name, :status, tags: [])
    end

    def set_todo_item
      @todo_item = TodoItem.find(id: params[:id])
    end

    def build_tags
      return [] if todo_item_params[:tags].blank?

      tags = []
      todo_item_params[:tags].each do |tag|
        tags << Tag.find_or_create_by(name: tag)
      end
      tags
    end
  end
end
