object @todo_item
attributes :id, :name, :status, :is_deleted
child :tags do
    attributes :name
end
