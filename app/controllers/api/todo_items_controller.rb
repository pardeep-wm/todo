# frozen_string_literal: true

module Api
  class TodoItemsController < ApplicationController
    respond_to? :json

    def index
      @todo_items = TodoItem.page(params[:page])
      render @todo_items
    end

    def create
      @todo_item = TodoItem.new(todo_item_params.except(:tags))
      tags = []
      todo_item_params[:tags].each do |tag|
        tags << Tag.find_or_create_by(name: tag)
      end
      @todo_item.tags << tags
      if @todo_item.save
        render @todo_item
      else
        render json: @todo_item.errors
      end
    end

    def update
      @todo_item = TodoItem.find(id: params[:id])
      if @todo_item.update(todo_item_params.except(:tags))
        render @todo_item
      else
        render json: @todo_item.errors
      end
    end

    def items_by_tag
      tags = params[:tag].split(',')
      tag_ids = Tag.where(:name.in => tags).pluck(:id)
      @todo_items = TodoItem.where(:tag_ids.in => tag_ids)
      return render json: { message: 'no data found' } if @todo_items.blank?

      render @todo_items
    end

    private

    def todo_item_params
      params.require(:todo_item).permit(:name, :status, tags: [])
    end
  end
end
